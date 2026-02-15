import { NavLink } from 'react-router-dom';
import { useAuth } from '../../auth/AuthContext';

const navItems = [
  { to: '/', label: 'Dashboard', icon: DashboardIcon },
  { to: '/cheques', label: 'Cheques', icon: ChequeIcon },
  { to: '/maintenance', label: 'Maintenance', icon: MaintenanceIcon },
  { to: '/units', label: 'Units', icon: UnitIcon },
];

export default function Sidebar() {
  const { user, logout } = useAuth();

  return (
    <aside className="flex h-screen w-64 flex-col bg-navy text-white">
      {/* Brand */}
      <div className="flex items-center gap-3 px-6 py-6">
        <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gold">
          <span className="text-lg font-bold text-navy">S</span>
        </div>
        <span className="text-xl font-bold tracking-tight">Sakani</span>
      </div>

      {/* Navigation */}
      <nav className="mt-2 flex-1 space-y-1 px-3">
        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            end={item.to === '/'}
            className={({ isActive }) =>
              `flex items-center gap-3 rounded-xl px-4 py-3 text-sm font-medium transition-colors ${
                isActive
                  ? 'bg-white/15 text-gold'
                  : 'text-white/70 hover:bg-white/10 hover:text-white'
              }`
            }
          >
            <item.icon />
            {item.label}
          </NavLink>
        ))}
      </nav>

      {/* User section */}
      <div className="border-t border-white/10 px-4 py-4">
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-teal text-sm font-bold text-white">
            {user?.full_name_en?.charAt(0) || 'U'}
          </div>
          <div className="flex-1 overflow-hidden">
            <p className="truncate text-sm font-medium">{user?.full_name_en || 'User'}</p>
            <p className="truncate text-xs text-white/50">{user?.role}</p>
          </div>
          <button
            onClick={logout}
            className="rounded-lg p-2 text-white/50 hover:bg-white/10 hover:text-white"
            title="Sign out"
          >
            <LogoutIcon />
          </button>
        </div>
      </div>
    </aside>
  );
}

function DashboardIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <rect x="2" y="2" width="7" height="7" rx="2" />
      <rect x="11" y="2" width="7" height="7" rx="2" />
      <rect x="2" y="11" width="7" height="7" rx="2" />
      <rect x="11" y="11" width="7" height="7" rx="2" />
    </svg>
  );
}

function ChequeIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <rect x="2" y="4" width="16" height="12" rx="2" />
      <path d="M2 8h16" />
      <path d="M6 12h4" />
    </svg>
  );
}

function MaintenanceIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <path d="M14.5 3.5l2 2-9 9-3 1 1-3 9-9z" />
      <path d="M12.5 5.5l2 2" />
    </svg>
  );
}

function UnitIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <path d="M3 18V6l7-4 7 4v12" />
      <path d="M3 18h14" />
      <rect x="7" y="10" width="6" height="8" rx="1" />
    </svg>
  );
}

function LogoutIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke="currentColor" strokeWidth="1.5">
      <path d="M6 15H3a1 1 0 01-1-1V4a1 1 0 011-1h3" />
      <path d="M12 12l3-3-3-3" />
      <path d="M15 9H7" />
    </svg>
  );
}
