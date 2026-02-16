import { useQuery } from '@tanstack/react-query';
import { leasesApi } from '../../api/compounds.api';
import DataTable from '../../components/shared/DataTable';
import StatusBadge from '../../components/shared/StatusBadge';

interface LeaseRow {
  id: string;
  tenant: string;
  tenant_name: string | null;
  tenant_phone: string | null;
  unit_number: string | null;
  compound_name: string | null;
  start_date: string;
  end_date: string;
  monthly_rent: string;
  status: string;
}

interface TenantRow {
  id: string;
  name: string;
  phone: string;
  unit: string;
  compound: string;
  leaseStatus: string;
  monthlyRent: string;
  leaseEnd: string;
  activeLeasesCount: number;
}

export default function TenantListPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['leases', 'tenants-view'],
    queryFn: () => leasesApi.list(),
  });

  const leases: LeaseRow[] = data?.results ?? data ?? [];

  // Group by tenant ID to build a unique tenant list
  const tenantMap = new Map<string, TenantRow>();
  for (const lease of leases) {
    if (!lease.tenant) continue;
    const existing = tenantMap.get(lease.tenant);
    if (!existing || lease.status === 'active') {
      tenantMap.set(lease.tenant, {
        id: lease.tenant,
        name: lease.tenant_name || '—',
        phone: lease.tenant_phone || '—',
        unit: lease.unit_number || '—',
        compound: lease.compound_name || '—',
        leaseStatus: lease.status,
        monthlyRent: lease.monthly_rent,
        leaseEnd: lease.end_date,
        activeLeasesCount: (existing?.activeLeasesCount || 0) +
          (lease.status === 'active' ? 1 : 0),
      });
    }
  }

  const tenants = Array.from(tenantMap.values());

  const columns = [
    {
      key: 'name',
      header: 'Tenant',
      render: (row: TenantRow) => (
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-teal-surface text-sm font-bold text-teal">
            {row.name.charAt(0).toUpperCase()}
          </div>
          <div>
            <p className="font-medium text-navy">{row.name}</p>
            <p className="text-xs text-text-muted">{row.phone}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'unit',
      header: 'Unit',
      render: (row: TenantRow) => (
        <div>
          <p className="font-medium">{row.unit}</p>
          <p className="text-xs text-text-muted">{row.compound}</p>
        </div>
      ),
    },
    {
      key: 'monthlyRent',
      header: 'Rent',
      render: (row: TenantRow) => (
        <span className="font-semibold">
          QAR {Number(row.monthlyRent).toLocaleString()}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'leaseEnd',
      header: 'Lease Until',
      render: (row: TenantRow) => (
        <span className="text-sm text-text-secondary">
          {new Date(row.leaseEnd).toLocaleDateString()}
        </span>
      ),
    },
    {
      key: 'leaseStatus',
      header: 'Status',
      render: (row: TenantRow) => <StatusBadge status={row.leaseStatus} />,
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-navy">Tenants</h1>
        <p className="mt-1 text-sm text-text-secondary">
          View all tenants across your properties
        </p>
      </div>

      <DataTable
        columns={columns}
        data={tenants}
        keyExtractor={(row) => row.id}
        isLoading={isLoading}
        emptyMessage="No tenants found"
      />
    </div>
  );
}
