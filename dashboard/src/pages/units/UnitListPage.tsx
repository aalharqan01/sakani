import { useQuery } from '@tanstack/react-query';
import { unitsApi } from '../../api/compounds.api';
import DataTable from '../../components/shared/DataTable';
import StatusBadge from '../../components/shared/StatusBadge';
import type { Unit } from '../../lib/types';

export default function UnitListPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['units'],
    queryFn: () => unitsApi.list(),
  });

  const columns = [
    {
      key: 'unit_number',
      header: 'Unit #',
      render: (row: Unit) => (
        <span className="font-medium text-navy">{row.unit_number}</span>
      ),
    },
    {
      key: 'compound_name',
      header: 'Compound',
    },
    {
      key: 'building_name',
      header: 'Building',
    },
    {
      key: 'unit_type',
      header: 'Type',
      render: (row: Unit) => <span className="capitalize">{row.unit_type}</span>,
    },
    {
      key: 'bedrooms',
      header: 'Bed / Bath',
      render: (row: Unit) => `${row.bedrooms} / ${row.bathrooms}`,
    },
    {
      key: 'floor',
      header: 'Floor',
    },
    {
      key: 'monthly_rent',
      header: 'Rent',
      render: (row: Unit) => (
        <span className="font-semibold">
          {row.monthly_rent ? `QAR ${Number(row.monthly_rent).toLocaleString()}` : '—'}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'status',
      header: 'Status',
      render: (row: Unit) => <StatusBadge status={row.status} />,
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-navy">Units</h1>
        <p className="mt-1 text-sm text-text-secondary">
          All units across your compounds
        </p>
      </div>

      <DataTable
        columns={columns}
        data={data?.results ?? []}
        keyExtractor={(row) => row.id}
        isLoading={isLoading}
        emptyMessage="No units found"
      />
    </div>
  );
}
