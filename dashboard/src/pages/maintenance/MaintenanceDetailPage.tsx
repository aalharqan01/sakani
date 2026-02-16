import { useParams, useNavigate } from 'react-router-dom';
import { useMaintenanceDetail, useCompleteMaintenance } from '../../hooks/useMaintenance';
import StatusBadge from '../../components/shared/StatusBadge';

export default function MaintenanceDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { data: request, isLoading } = useMaintenanceDetail(id!);
  const completeMutation = useCompleteMaintenance();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-24">
        <div className="h-8 w-8 animate-spin rounded-full border-4 border-navy border-t-transparent" />
      </div>
    );
  }

  if (!request) {
    return (
      <div className="py-24 text-center text-text-muted">
        Request not found
      </div>
    );
  }

  const handleComplete = () => {
    if (confirm('Mark this request as completed?')) {
      completeMutation.mutate({ id: request.id });
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <button
            onClick={() => navigate(-1)}
            className="mb-2 text-sm text-text-secondary hover:text-navy"
          >
            &larr; Back to list
          </button>
          <h1 className="text-2xl font-bold text-navy">{request.title}</h1>
          <p className="mt-1 text-sm text-text-secondary">
            {request.reference_number}
          </p>
        </div>
        <StatusBadge status={request.status} className="text-sm px-3 py-1" />
      </div>

      {/* Info cards */}
      <div className="grid grid-cols-3 gap-4">
        <InfoCard label="Category" value={request.category_name || '—'} />
        <InfoCard label="Urgency" value={request.urgency} capitalize />
        <InfoCard
          label="Created"
          value={new Date(request.created_at).toLocaleDateString()}
        />
        <InfoCard label="Tenant" value={request.tenant_name || '—'} />
        <InfoCard label="Unit" value={request.unit_number || '—'} />
        <InfoCard label="Compound" value={request.compound_name || '—'} />
      </div>

      {/* Actions */}
      {request.status !== 'completed' && request.status !== 'confirmed' && (
        <div className="flex gap-3">
          <button
            onClick={handleComplete}
            disabled={completeMutation.isPending}
            className="rounded-xl bg-success px-6 py-2.5 text-sm font-semibold text-white hover:bg-green-600 disabled:opacity-50"
          >
            {completeMutation.isPending ? 'Completing...' : 'Mark Complete'}
          </button>
        </div>
      )}
    </div>
  );
}

function InfoCard({
  label,
  value,
  capitalize,
}: {
  label: string;
  value: string;
  capitalize?: boolean;
}) {
  return (
    <div className="rounded-2xl border border-border-light bg-white p-5">
      <p className="text-xs font-semibold uppercase tracking-wider text-text-muted">
        {label}
      </p>
      <p className={`mt-1 text-lg font-medium text-navy ${capitalize ? 'capitalize' : ''}`}>
        {value}
      </p>
    </div>
  );
}
