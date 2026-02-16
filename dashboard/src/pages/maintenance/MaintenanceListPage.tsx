import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useMaintenanceRequests } from '../../hooks/useMaintenance';
import DataTable from '../../components/shared/DataTable';
import StatusBadge from '../../components/shared/StatusBadge';
import type { MaintenanceRequest } from '../../lib/types';

const statusFilters = ['all', 'submitted', 'in_progress', 'completed', 'cancelled'] as const;

export default function MaintenanceListPage() {
  const navigate = useNavigate();
  const [filter, setFilter] = useState<string>('all');
  const params = filter !== 'all' ? { status: filter } : undefined;
  const { data, isLoading } = useMaintenanceRequests(params);

  const columns = [
    {
      key: 'reference_number',
      header: 'Ref #',
      render: (row: MaintenanceRequest) => (
        <span className="font-medium text-navy">{row.reference_number}</span>
      ),
    },
    {
      key: 'title',
      header: 'Title',
      render: (row: MaintenanceRequest) => (
        <div>
          <p className="font-medium">{row.title}</p>
          <p className="text-xs text-text-muted">{row.category_name || row.category || '—'}</p>
        </div>
      ),
    },
    {
      key: 'tenant_name',
      header: 'Tenant',
      render: (row: MaintenanceRequest) => (
        <div>
          <p>{row.tenant_name || '—'}</p>
          <p className="text-xs text-text-muted">{row.unit_number || ''}</p>
        </div>
      ),
    },
    {
      key: 'compound_name',
      header: 'Compound',
    },
    {
      key: 'urgency',
      header: 'Urgency',
      render: (row: MaintenanceRequest) => {
        const color =
          row.urgency === 'emergency'
            ? 'text-error font-semibold'
            : row.urgency === 'high'
              ? 'text-warning font-medium'
              : 'text-text-secondary';
        return <span className={`capitalize ${color}`}>{row.urgency}</span>;
      },
    },
    {
      key: 'status',
      header: 'Status',
      render: (row: MaintenanceRequest) => <StatusBadge status={row.status} />,
    },
    {
      key: 'created_at',
      header: 'Created',
      render: (row: MaintenanceRequest) => (
        <span className="text-text-muted">
          {new Date(row.created_at).toLocaleDateString()}
        </span>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-navy">Maintenance</h1>
        <p className="mt-1 text-sm text-text-secondary">
          Track and manage maintenance requests
        </p>
      </div>

      {/* Filter tabs */}
      <div className="flex gap-2">
        {statusFilters.map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={`rounded-full px-4 py-2 text-sm font-medium capitalize transition-colors ${
              filter === s
                ? 'bg-navy text-white'
                : 'bg-white text-text-secondary hover:bg-cream-dark'
            }`}
          >
            {s === 'in_progress' ? 'In Progress' : s}
          </button>
        ))}
      </div>

      {/* Table */}
      <DataTable
        columns={columns}
        data={data?.results ?? []}
        keyExtractor={(row) => row.id}
        onRowClick={(row) => navigate(`/maintenance/${row.id}`)}
        isLoading={isLoading}
        emptyMessage="No maintenance requests found"
      />
    </div>
  );
}
