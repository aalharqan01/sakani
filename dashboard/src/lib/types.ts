export interface User {
  id: string;
  phone_number: string;
  role: 'tenant' | 'landlord' | 'maintenance' | 'admin';
  full_name_en: string | null;
  full_name_ar: string | null;
  email: string | null;
  preferred_language: string;
}

export interface Cheque {
  id: string;
  lease: string;
  cheque_number: string;
  bank_name: string;
  bank_branch: string | null;
  amount: string;
  currency: string;
  due_date: string;
  payee_name: string | null;
  status: string;
  deposited_date: string | null;
  cleared_date: string | null;
  bounced_date: string | null;
  bounce_reason: string | null;
  replaces: string | null;
  image: string | null;
  sequence_number: number;
  notes: string | null;
  is_overdue: boolean;
  tenant_name: string | null;
  unit_number: string | null;
  status_logs?: ChequeStatusLog[];
  created_at: string;
  updated_at: string;
}

export interface ChequeStatusLog {
  id: string;
  from_status: string;
  to_status: string;
  changed_by: string | null;
  changed_by_name: string | null;
  notes: string | null;
  created_at: string;
}

export interface ChequeDashboard {
  total: number;
  pending: number;
  cleared: number;
  bounced: number;
  deposited: number;
  overdue: number;
  total_amount: string;
  cleared_amount: string;
}

export interface MaintenanceRequest {
  id: string;
  reference_number: string;
  title: string;
  category: string | null;
  category_name: string | null;
  urgency: string;
  status: string;
  tenant_name: string | null;
  unit_number: string | null;
  compound_name: string | null;
  image_count: number;
  created_at: string;
}

export interface Unit {
  id: string;
  unit_number: string;
  floor: number;
  unit_type: string;
  bedrooms: number;
  bathrooms: number;
  monthly_rent: string | null;
  status: string;
  building_name: string;
  compound_name: string;
}

export interface PaginatedResponse<T> {
  count: number;
  next: string | null;
  previous: string | null;
  results: T[];
}
