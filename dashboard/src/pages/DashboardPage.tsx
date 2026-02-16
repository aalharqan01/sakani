import { useAuth } from '../auth/AuthContext';
import { useChequeDashboard, useOverdueCheques, useUpcomingCheques } from '../hooks/useCheques';
import { useMaintenanceRequests } from '../hooks/useMaintenance';
import StatCard from '../components/shared/StatCard';
import StatusBadge from '../components/shared/StatusBadge';

export default function DashboardPage() {
  const { user } = useAuth();
  const { data: dashboard, isLoading: dashLoading } = useChequeDashboard();
  const { data: overdue } = useOverdueCheques();
  const { data: maintenance } = useMaintenanceRequests({ status: 'in_progress' });

  const greeting = getGreeting();

  return (
    <div className="space-y-8">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-navy">
          {greeting}, {user?.full_name_en?.split(' ')[0] || 'Admin'}
        </h1>
        <p className="mt-1 text-sm text-text-secondary">
          Here's what's happening with your properties today.
        </p>
      </div>

      {/* Stat cards */}
      <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Total Cheques"
          value={dashLoading ? '...' : dashboard?.total ?? 0}
          icon={<ChequeIcon />}
        />
        <StatCard
          label="Cleared"
          value={dashLoading ? '...' : dashboard?.cleared ?? 0}
          icon={<CheckIcon />}
        />
        <StatCard
          label="Pending"
          value={dashLoading ? '...' : dashboard?.pending ?? 0}
          icon={<ClockIcon />}
        />
        <StatCard
          label="Bounced"
          value={dashLoading ? '...' : dashboard?.bounced ?? 0}
          icon={<AlertIcon />}
        />
      </div>

      {/* Next Payment Tracker + Active Maintenance */}
      <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
        {/* Next Payment Card — matches sakani_indigo rent-card design */}
        <NextPaymentCard dashboard={dashboard} isLoading={dashLoading} />

        {/* Active maintenance card */}
        <div className="rounded-2xl border border-border-light bg-white p-6">
          <div className="flex items-center justify-between">
            <h3 className="font-semibold text-navy">Active Maintenance</h3>
            <StatusBadge status="in_progress" />
          </div>
          <p className="mt-3 text-3xl font-bold text-navy">
            {maintenance?.count ?? 0}
          </p>
          <p className="mt-1 text-sm text-text-secondary">
            requests in progress
          </p>
        </div>
      </div>

      {/* Overdue cheques */}
      {overdue && overdue.length > 0 && (
        <div className="rounded-2xl border border-error/20 bg-error-surface p-6">
          <h3 className="font-semibold text-red-800">
            Overdue Cheques ({overdue.length})
          </h3>
          <div className="mt-4 space-y-3">
            {overdue.slice(0, 5).map((cheque) => (
              <div
                key={cheque.id}
                className="flex items-center justify-between rounded-xl bg-white px-4 py-3"
              >
                <div>
                  <p className="text-sm font-medium text-text-primary">
                    Cheque #{cheque.cheque_number}
                  </p>
                  <p className="text-xs text-text-muted">
                    {cheque.tenant_name} · {cheque.unit_number}
                  </p>
                </div>
                <div className="text-right">
                  <p className="text-sm font-bold text-error">
                    QAR {Number(cheque.amount).toLocaleString()}
                  </p>
                  <p className="text-xs text-text-muted">Due: {cheque.due_date}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

function getGreeting() {
  const h = new Date().getHours();
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}

/* eslint-disable @typescript-eslint/no-explicit-any */
function NextPaymentCard({ dashboard, isLoading }: { dashboard: any; isLoading: boolean }) {
  const { data: upcoming } = useUpcomingCheques();
  const nextCheque = upcoming?.[0];

  const cleared = Number(dashboard?.cleared ?? 0);
  const total = Number(dashboard?.total ?? 0);
  const pct = total > 0 ? Math.round((cleared / total) * 100) : 0;

  const dueDate = nextCheque?.due_date
    ? new Date(nextCheque.due_date).toLocaleDateString('en-US', {
        month: 'long',
        day: 'numeric',
        year: 'numeric',
      })
    : '—';

  const amount = nextCheque
    ? Number(nextCheque.amount).toLocaleString()
    : Number(dashboard?.total_amount ?? 0).toLocaleString();

  return (
    <div
      className="relative overflow-hidden rounded-2xl p-6"
      style={{
        background: 'linear-gradient(135deg, #1E1B4B 0%, #312E81 100%)',
        boxShadow: '0 10px 32px rgba(30,27,75,0.25)',
      }}
    >
      {/* Decorative circle — top right */}
      <div
        className="pointer-events-none absolute"
        style={{
          top: '-30px',
          right: '-30px',
          width: '140px',
          height: '140px',
          borderRadius: '50%',
          background: 'rgba(129,140,248,0.15)',
        }}
      />
      {/* Decorative circle — bottom center-left */}
      <div
        className="pointer-events-none absolute"
        style={{
          bottom: '-20px',
          left: '30%',
          width: '100px',
          height: '100px',
          borderRadius: '50%',
          background: 'rgba(129,140,248,0.08)',
        }}
      />

      {/* Top row: label + badge */}
      <div className="relative z-10 mb-4 flex items-center justify-between">
        <span className="text-[13px] font-medium" style={{ color: 'rgba(255,255,255,0.6)' }}>
          Next Payment
        </span>
        <div
          className="flex items-center gap-1.5 rounded-xl px-3 py-1"
          style={{ background: 'rgba(255,255,255,0.12)' }}
        >
          <div className="h-1.5 w-1.5 rounded-full" style={{ background: '#A5B4FC' }} />
          <span className="text-[11px] font-semibold text-white">On Track</span>
        </div>
      </div>

      {/* Currency */}
      <p className="relative z-10 text-[13px] font-medium" style={{ color: 'rgba(255,255,255,0.55)' }}>
        QAR
      </p>

      {/* Amount */}
      <p className="relative z-10 my-1 text-[46px] font-bold leading-none text-white">
        {isLoading ? '...' : amount}
      </p>

      {/* Due date */}
      <p className="relative z-10 mb-5 text-[13px]" style={{ color: 'rgba(255,255,255,0.5)' }}>
        Due {dueDate}
      </p>

      {/* Progress section */}
      <div className="relative z-10">
        <div className="mb-2 flex items-center justify-between">
          <span className="text-xs font-medium" style={{ color: 'rgba(255,255,255,0.55)' }}>
            {cleared} of {total} cheques cleared
          </span>
          <span className="text-xs font-bold" style={{ color: '#A5B4FC' }}>
            {pct}%
          </span>
        </div>
        <div
          className="h-[5px] overflow-hidden rounded-full"
          style={{ background: 'rgba(255,255,255,0.15)' }}
        >
          <div
            className="h-full rounded-full transition-all duration-500"
            style={{ width: `${pct}%`, background: '#A5B4FC' }}
          />
        </div>
      </div>
    </div>
  );
}
/* eslint-enable @typescript-eslint/no-explicit-any */

function ChequeIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <rect x="2" y="4" width="16" height="12" rx="2" />
      <path d="M2 8h16" />
      <path d="M6 12h4" />
    </svg>
  );
}

function CheckIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <path d="M5 10l3 3 7-7" />
    </svg>
  );
}

function ClockIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <circle cx="10" cy="10" r="8" />
      <path d="M10 6v4l3 2" />
    </svg>
  );
}

function AlertIcon() {
  return (
    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
      <path d="M10 3l8 14H2L10 3z" />
      <path d="M10 9v3" />
      <circle cx="10" cy="14.5" r="0.5" fill="currentColor" />
    </svg>
  );
}
