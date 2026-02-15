import { CHEQUE_STATUS, MAINTENANCE_STATUS } from '../../lib/constants';

const statusStyles: Record<string, string> = {
  pending: 'bg-gold-surface text-yellow-800',
  deposited: 'bg-teal-surface text-teal-dark',
  cleared: 'bg-success-surface text-green-800',
  bounced: 'bg-error-surface text-red-800',
  replaced: 'bg-gray-100 text-gray-600',
  cancelled: 'bg-gray-100 text-gray-600',
  void: 'bg-gray-100 text-gray-600',
  submitted: 'bg-teal-surface text-teal-dark',
  acknowledged: 'bg-teal-surface text-teal-dark',
  quoted: 'bg-gold-surface text-yellow-800',
  quote_accepted: 'bg-success-surface text-green-800',
  quote_rejected: 'bg-error-surface text-red-800',
  scheduled: 'bg-teal-surface text-teal-dark',
  in_progress: 'bg-warning-surface text-yellow-800',
  completed: 'bg-success-surface text-green-800',
  confirmed: 'bg-success-surface text-green-800',
  overdue: 'bg-error-surface text-red-800',
  occupied: 'bg-success-surface text-green-800',
  vacant: 'bg-teal-surface text-teal-dark',
  active: 'bg-success-surface text-green-800',
};

const allLabels: Record<string, string> = {
  ...CHEQUE_STATUS,
  ...MAINTENANCE_STATUS,
  overdue: 'Overdue',
  occupied: 'Occupied',
  vacant: 'Vacant',
  active: 'Active',
};

interface StatusBadgeProps {
  status: string;
  className?: string;
}

export default function StatusBadge({ status, className = '' }: StatusBadgeProps) {
  const style = statusStyles[status] || 'bg-gray-100 text-gray-600';
  const label = allLabels[status] || status;

  return (
    <span
      className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold ${style} ${className}`}
    >
      {label}
    </span>
  );
}
