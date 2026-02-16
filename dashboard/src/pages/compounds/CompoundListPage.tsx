import { useQuery } from '@tanstack/react-query';
import { compoundsApi } from '../../api/compounds.api';
import DataTable from '../../components/shared/DataTable';
import StatCard from '../../components/shared/StatCard';

interface Compound {
  id: string;
  name_en: string;
  name_ar: string | null;
  city: string;
  area: string | null;
  total_buildings: number;
  total_units: number;
  occupied_units: number;
  created_at: string;
}

export default function CompoundListPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['compounds'],
    queryFn: compoundsApi.list,
  });

  const compounds: Compound[] = data?.results ?? data ?? [];

  const totalUnits = compounds.reduce((sum, c) => sum + (c.total_units || 0), 0);
  const occupiedUnits = compounds.reduce((sum, c) => sum + (c.occupied_units || 0), 0);
  const occupancyRate = totalUnits > 0 ? Math.round((occupiedUnits / totalUnits) * 100) : 0;

  const columns = [
    {
      key: 'name_en',
      header: 'Name',
      render: (row: Compound) => (
        <div>
          <p className="font-medium text-navy">{row.name_en}</p>
          {row.name_ar && <p className="text-xs text-text-muted">{row.name_ar}</p>}
        </div>
      ),
    },
    {
      key: 'city',
      header: 'City',
    },
    {
      key: 'area',
      header: 'Area',
      render: (row: Compound) => <span>{row.area || '—'}</span>,
    },
    {
      key: 'total_buildings',
      header: 'Buildings',
      render: (row: Compound) => (
        <span className="font-medium">{row.total_buildings || 0}</span>
      ),
    },
    {
      key: 'total_units',
      header: 'Units',
      render: (row: Compound) => (
        <span className="font-medium">{row.total_units || 0}</span>
      ),
    },
    {
      key: 'occupied_units',
      header: 'Occupancy',
      render: (row: Compound) => {
        const total = row.total_units || 0;
        const occupied = row.occupied_units || 0;
        const rate = total > 0 ? Math.round((occupied / total) * 100) : 0;
        return (
          <div className="flex items-center gap-2">
            <div className="h-2 w-20 rounded-full bg-gray-100">
              <div
                className="h-2 rounded-full bg-teal"
                style={{ width: `${rate}%` }}
              />
            </div>
            <span className="text-sm text-text-secondary">{rate}%</span>
          </div>
        );
      },
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-navy">Compounds</h1>
        <p className="mt-1 text-sm text-text-secondary">
          Manage your properties and compounds
        </p>
      </div>

      {/* Summary stats */}
      <div className="grid grid-cols-4 gap-4">
        <StatCard label="Compounds" value={compounds.length} />
        <StatCard label="Total Units" value={totalUnits} />
        <StatCard label="Occupied" value={occupiedUnits} />
        <StatCard label="Occupancy Rate" value={`${occupancyRate}%`} />
      </div>

      <DataTable
        columns={columns}
        data={compounds}
        keyExtractor={(row) => row.id}
        isLoading={isLoading}
        emptyMessage="No compounds found"
      />
    </div>
  );
}
