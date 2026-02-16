import { useQuery } from '@tanstack/react-query';
import { leasesApi } from '../../api/compounds.api';
import DataTable from '../../components/shared/DataTable';
import StatusBadge from '../../components/shared/StatusBadge';

interface Lease {
  id: string;
  tenant_name: string | null;
  tenant_phone: string | null;
  unit_number: string | null;
  compound_name: string | null;
  start_date: string;
  end_date: string;
  monthly_rent: string;
  status: string;
  total_cheques: number;
  cleared_cheques: number;
}

export default function LeaseListPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['leases'],
    queryFn: () => leasesApi.list(),
  });

  const leases: Lease[] = data?.results ?? data ?? [];

  const columns = [
    {
      key: 'tenant_name',
      header: 'Tenant',
      render: (row: Lease) => (
        <div>
          <p className="font-medium text-navy">{row.tenant_name || '—'}</p>
          {row.tenant_phone && (
            <p className="text-xs text-text-muted">{row.tenant_phone}</p>
          )}
        </div>
      ),
    },
    {
      key: 'unit_number',
      header: 'Unit',
      render: (row: Lease) => (
        <div>
          <p className="font-medium">{row.unit_number || '—'}</p>
          <p className="text-xs text-text-muted">{row.compound_name || ''}</p>
        </div>
      ),
    },
    {
      key: 'start_date',
      header: 'Lease Period',
      render: (row: Lease) => (
        <div>
          <p className="text-sm">
            {new Date(row.start_date).toLocaleDateString()} –{' '}
            {new Date(row.end_date).toLocaleDateString()}
          </p>
        </div>
      ),
    },
    {
      key: 'monthly_rent',
      header: 'Rent',
      render: (row: Lease) => (
        <span className="font-semibold">
          QAR {Number(row.monthly_rent).toLocaleString()}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'cheques',
      header: 'Cheques',
      render: (row: Lease) => {
        const total = row.total_cheques || 0;
        const cleared = row.cleared_cheques || 0;
        return (
          <span className="text-sm text-text-secondary">
            {cleared} / {total} cleared
          </span>
        );
      },
    },
    {
      key: 'status',
      header: 'Status',
      render: (row: Lease) => <StatusBadge status={row.status} />,
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-navy">Leases</h1>
        <p className="mt-1 text-sm text-text-secondary">
          Manage tenant leases and contracts
        </p>
      </div>

      <DataTable
        columns={columns}
        data={leases}
        keyExtractor={(row) => row.id}
        isLoading={isLoading}
        emptyMessage="No leases found"
      />
    </div>
  );
}
