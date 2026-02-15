import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useCheques, useChequeDashboard } from '../../hooks/useCheques';
import DataTable from '../../components/shared/DataTable';
import StatusBadge from '../../components/shared/StatusBadge';
import StatCard from '../../components/shared/StatCard';
import type { Cheque } from '../../lib/types';

const statusFilters = ['all', 'pending', 'deposited', 'cleared', 'bounced'] as const;

export default function ChequeListPage() {
  const navigate = useNavigate();
  const [filter, setFilter] = useState<string>('all');
  const params = filter !== 'all' ? { status: filter } : undefined;
  const { data, isLoading } = useCheques(params);
  const { data: dashboard } = useChequeDashboard();

  const columns = [
    {
      key: 'cheque_number',
      header: 'Cheque #',
      render: (row: Cheque) => (
        <span className="font-medium text-navy">#{row.cheque_number}</span>
      ),
    },
    {
      key: 'tenant_name',
      header: 'Tenant',
      render: (row: Cheque) => (
        <div>
          <p className="font-medium">{row.tenant_name || '—'}</p>
          <p className="text-xs text-text-muted">{row.unit_number || ''}</p>
        </div>
      ),
    },
    {
      key: 'bank_name',
      header: 'Bank',
    },
    {
      key: 'amount',
      header: 'Amount',
      render: (row: Cheque) => (
        <span className="font-semibold">
          QAR {Number(row.amount).toLocaleString()}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'due_date',
      header: 'Due Date',
      render: (row: Cheque) => (
        <span className={row.is_overdue ? 'font-medium text-error' : ''}>
          {row.due_date}
        </span>
      ),
    },
    {
      key: 'status',
      header: 'Status',
      render: (row: Cheque) => <StatusBadge status={row.status} />,
    },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-navy">Cheques</h1>
          <p className="mt-1 text-sm text-text-secondary">
            Manage and track all rent cheques
          </p>
        </div>
      </div>

      {/* Summary stats */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-5">
        <StatCard label="Total" value={dashboard?.total ?? 0} />
        <StatCard label="Pending" value={dashboard?.pending ?? 0} />
        <StatCard label="Deposited" value={dashboard?.deposited ?? 0} />
        <StatCard label="Cleared" value={dashboard?.cleared ?? 0} />
        <StatCard label="Bounced" value={dashboard?.bounced ?? 0} />
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
            {s}
          </button>
        ))}
      </div>

      {/* Table */}
      <DataTable
        columns={columns}
        data={data?.results ?? []}
        keyExtractor={(row) => row.id}
        onRowClick={(row) => navigate(`/cheques/${row.id}`)}
        isLoading={isLoading}
        emptyMessage="No cheques found"
      />
    </div>
  );
}
