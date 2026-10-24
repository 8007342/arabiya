// Official GIS button; credentials go only to this app's same-origin Worker.
(() => {
  let sdk;
  let initialized;
  let activeCallback;
  function loadSdk() {
    if (window.google?.accounts?.id) return Promise.resolve();
    if (!sdk) sdk = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = 'https://accounts.google.com/gsi/client';
      script.async = true;
      const timer = setTimeout(() => reject(new Error('Google could not load. Check your connection and retry.')), 15000);
      script.onload = () => { clearTimeout(timer); resolve(); };
      script.onerror = () => { clearTimeout(timer); sdk = null; reject(new Error('Google could not load. Please retry.')); };
      document.head.append(script);
    });
    return sdk;
  }
  async function initialize() {
    const configResponse = await fetch('/api/config', { credentials: 'same-origin' });
    const config = await configResponse.json();
    if (!config.googleEnabled) throw new Error('Cloud sign-in is unavailable right now. You can keep playing on this device.');
    const challengeResponse = await fetch('/api/auth/google/challenge', { credentials: 'same-origin' });
    const challenge = await challengeResponse.json();
    if (!challengeResponse.ok) throw new Error(challenge.error || 'Could not start sign-in.');
    await loadSdk();
    window.google.accounts.id.initialize({
      client_id: config.googleClientId,
      nonce: challenge.nonce,
      auto_select: false,
      ux_mode: 'popup',
      callback: async ({ credential }) => {
        try {
          const response = await fetch('/api/auth/google', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'content-type': 'application/json' },
            body: JSON.stringify({ credential }),
          });
          const body = await response.json();
          if (!response.ok) throw new Error(body.error || 'Sign-in failed.');
          initialized = null;
          activeCallback?.('');
        } catch (error) { initialized = null; activeCallback?.(error.message || 'Sign-in failed. Please retry.'); }
      },
    });
  }
  window.arabiyaRenderGoogleButton = async (element, callback) => {
    activeCallback = callback;
    try {
      initialized ||= initialize().catch(error => { initialized = null; throw error; });
      await initialized;
      if (!element.isConnected) return;
      window.google.accounts.id.renderButton(element, {
        type: 'standard', theme: 'outline', size: 'large',
        text: 'signin_with', shape: 'pill', width: 280,
      });
    } catch (error) { callback(error.message || 'Sign-in unavailable.'); }
  };
})();
