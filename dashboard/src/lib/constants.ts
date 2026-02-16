export const API_BASE_URL = '/api/v1';

export const COLORS = {
  navy: '#1E1B4B',
  navyLight: '#312E81',
  teal: '#14B8A6',
  tealDark: '#0D9488',
  gold: '#F5D547',
  cream: '#FFFBF5',
  success: '#22C55E',
  warning: '#F59E0B',
  error: '#EF4444',
} as const;

export const CHEQUE_STATUS = {
  pending: 'Pending',
  deposited: 'Deposited',
  cleared: 'Cleared',
  bounced: 'Bounced',
  replaced: 'Replaced',
  cancelled: 'Cancelled',
  void: 'Void',
} as const;

export const MAINTENANCE_STATUS = {
  submitted: 'Submitted',
  acknowledged: 'Acknowledged',
  quoted: 'Quoted',
  quote_accepted: 'Quote Accepted',
  quote_rejected: 'Quote Rejected',
  scheduled: 'Scheduled',
  in_progress: 'In Progress',
  completed: 'Completed',
  confirmed: 'Confirmed',
  cancelled: 'Cancelled',
} as const;
