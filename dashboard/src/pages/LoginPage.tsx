import { useState, type FormEvent } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';

export default function LoginPage() {
  const { login, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  if (isAuthenticated) {
    navigate('/', { replace: true });
    return null;
  }

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      await login(phone, password);
      navigate('/', { replace: true });
    } catch {
      setError('Invalid phone number or password');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen">
      {/* Left: Navy hero panel with gradient + decorative circles */}
      <div
        className="relative hidden w-1/2 flex-col justify-between overflow-hidden p-12 lg:flex"
        style={{ background: 'linear-gradient(160deg, #1E1B4B 0%, #312E81 60%, #4338CA 100%)' }}
      >
        {/* Decorative circle — bottom right */}
        <div
          className="pointer-events-none absolute"
          style={{
            bottom: '-80px',
            right: '-60px',
            width: '280px',
            height: '280px',
            borderRadius: '50%',
            background: 'rgba(129,140,248,0.15)',
          }}
        />
        {/* Decorative circle — top left */}
        <div
          className="pointer-events-none absolute"
          style={{
            top: '60px',
            left: '-40px',
            width: '180px',
            height: '180px',
            borderRadius: '50%',
            background: 'rgba(129,140,248,0.08)',
          }}
        />
        {/* Decorative circle — mid-right accent */}
        <div
          className="pointer-events-none absolute"
          style={{
            top: '40%',
            right: '10%',
            width: '120px',
            height: '120px',
            borderRadius: '50%',
            background: 'rgba(129,140,248,0.06)',
          }}
        />

        <div className="relative z-10 flex items-center gap-3">
          <div className="flex h-11 w-11 items-center justify-center rounded-xl" style={{ background: '#6366F1' }}>
            <span className="text-lg font-bold text-white">S</span>
          </div>
          <span className="text-2xl font-bold text-white">Sakani</span>
        </div>
        <div className="relative z-10">
          <h1 className="text-4xl font-bold leading-tight text-white">
            Property Management<br />Made Simple
          </h1>
          <p className="mt-4 max-w-md text-lg" style={{ color: 'rgba(255,255,255,0.6)' }}>
            Track cheques, manage maintenance requests, and oversee your compounds — all in one place.
          </p>
        </div>
        <p className="relative z-10 text-sm" style={{ color: 'rgba(255,255,255,0.3)' }}>© 2026 Sakani. All rights reserved.</p>
      </div>

      {/* Right: Login form */}
      <div className="flex w-full flex-col items-center justify-center bg-cream px-6 lg:w-1/2">
        {/* Mobile brand */}
        <div className="mb-8 flex items-center gap-3 lg:hidden">
          <div className="flex h-11 w-11 items-center justify-center rounded-xl" style={{ background: '#6366F1' }}>
            <span className="text-lg font-bold text-white">S</span>
          </div>
          <span className="text-2xl font-bold text-navy">Sakani</span>
        </div>

        <div className="w-full max-w-md">
          <h2 className="text-2xl font-bold text-navy">Welcome back</h2>
          <p className="mt-2 text-sm text-text-secondary">Sign in to your dashboard</p>

          {error && (
            <div className="mt-4 rounded-xl bg-error-surface px-4 py-3 text-sm text-red-800">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="mt-8 space-y-5">
            <div>
              <label className="mb-1.5 block text-sm font-medium text-text-primary">
                Phone Number
              </label>
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="+974 XXXX XXXX"
                required
                className="w-full rounded-xl border border-border bg-white px-4 py-3 text-sm outline-none transition-colors focus:border-[#6366F1] focus:ring-2 focus:ring-[#6366F1]/20"
              />
            </div>
            <div>
              <label className="mb-1.5 block text-sm font-medium text-text-primary">
                Password
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Enter your password"
                required
                className="w-full rounded-xl border border-border bg-white px-4 py-3 text-sm outline-none transition-colors focus:border-[#6366F1] focus:ring-2 focus:ring-[#6366F1]/20"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="flex w-full items-center justify-center gap-2 rounded-[14px] py-3.5 text-sm font-bold text-white transition-all hover:-translate-y-0.5 disabled:opacity-60"
              style={{
                background: '#6366F1',
                boxShadow: '0 4px 20px rgba(99,102,241,0.45)',
              }}
            >
              {loading ? (
                <div className="h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
              ) : (
                <>
                  Sign In
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                    <line x1="5" y1="12" x2="19" y2="12" />
                    <polyline points="12 5 19 12 12 19" />
                  </svg>
                </>
              )}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
