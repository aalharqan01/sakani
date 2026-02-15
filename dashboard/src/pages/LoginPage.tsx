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
      {/* Left: Navy hero panel */}
      <div className="hidden w-1/2 flex-col justify-between bg-navy p-12 lg:flex">
        <div className="flex items-center gap-3">
          <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-gold">
            <span className="text-lg font-bold text-navy">S</span>
          </div>
          <span className="text-2xl font-bold text-white">Sakani</span>
        </div>
        <div>
          <h1 className="text-4xl font-bold leading-tight text-white">
            Property Management<br />Made Simple
          </h1>
          <p className="mt-4 max-w-md text-lg text-white/60">
            Track cheques, manage maintenance requests, and oversee your compounds — all in one place.
          </p>
        </div>
        <p className="text-sm text-white/30">© 2026 Sakani. All rights reserved.</p>
      </div>

      {/* Right: Login form */}
      <div className="flex w-full flex-col items-center justify-center bg-cream px-6 lg:w-1/2">
        {/* Mobile brand */}
        <div className="mb-8 flex items-center gap-3 lg:hidden">
          <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-gold">
            <span className="text-lg font-bold text-navy">S</span>
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
                className="w-full rounded-xl border border-border bg-white px-4 py-3 text-sm outline-none transition-colors focus:border-teal focus:ring-2 focus:ring-teal/20"
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
                className="w-full rounded-xl border border-border bg-white px-4 py-3 text-sm outline-none transition-colors focus:border-teal focus:ring-2 focus:ring-teal/20"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="flex w-full items-center justify-center gap-2 rounded-xl bg-gold py-3.5 text-sm font-bold text-navy transition-colors hover:bg-gold-light disabled:opacity-60"
            >
              {loading ? (
                <div className="h-5 w-5 animate-spin rounded-full border-2 border-navy border-t-transparent" />
              ) : (
                <>
                  Sign In
                  <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M3 8h10m-4-4 4 4-4 4" />
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
