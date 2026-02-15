import { useAuth } from '../auth/AuthContext';
import { useChequeDashboard, useOverdueCheques } from '../hooks/useCheques';
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

      {/* Summary row */}
      <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
        {/* Total amount card */}
        <div className="rounded-2xl bg-navy p-6 text-white">
          <p className="text-sm font-medium text-white/60">Total Cheque Amount</p>
          <p className="mt-2 text-3xl font-bold">
            QAR {dashLoading ? '...' : Number(dashboard?.total_amount ?? 0).toLocaleString()}
          </p>
          <div className="mt-4 flex items-center gap-4 text-sm text-white/50">
            <span>Cleared: QAR {Number(dashboard?.cleared_amount ?? 0).toLocaleString()}</span>
            <span>·</span>
            <span>{dashboard?.overdue ?? 0} overdue</span>
          </div>
        </div>

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
