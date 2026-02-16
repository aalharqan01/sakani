import { useParams, useNavigate } from 'react-router-dom';
import { useChequeDetail, useDepositCheque, useClearCheque, useBounceCheque } from '../../hooks/useCheques';
import StatusBadge from '../../components/shared/StatusBadge';

export default function ChequeDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { data: cheque, isLoading } = useChequeDetail(id!);
  const deposit = useDepositCheque();
  const clear = useClearCheque();
  const bounce = useBounceCheque();

  if (isLoading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="h-8 w-8 animate-spin rounded-full border-4 border-navy border-t-transparent" />
      </div>
    );
  }

  if (!cheque) {
    return (
      <div className="py-20 text-center text-text-muted">Cheque not found</div>
    );
  }

  const canDeposit = cheque.status === 'pending';
  const canClear = cheque.status === 'deposited';
  const canBounce = cheque.status === 'deposited';

  return (
    <div className="mx-auto max-w-3xl space-y-6">
      {/* Back button */}
      <button
        onClick={() => navigate('/cheques')}
        className="flex items-center gap-2 text-sm font-medium text-text-secondary hover:text-navy"
      >
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M10 4l-4 4 4 4" />
        </svg>
        Back to Cheques
      </button>

      {/* Hero */}
      <div className="rounded-2xl bg-navy p-8 text-white">
        <div className="flex items-start justify-between">
          <div>
            <StatusBadge status={cheque.status} className="mb-3" />
            <p className="text-sm text-white/50">Amount</p>
            <p className="mt-1 text-4xl font-bold">
              QAR {Number(cheque.amount).toLocaleString()}
            </p>
            <p className="mt-2 text-sm text-white/60">
              Cheque #{cheque.cheque_number} · {cheque.bank_name}
            </p>
          </div>
        </div>
      </div>

      {/* Info card */}
      <div className="rounded-2xl border border-border-light bg-white p-6">
        <h3 className="mb-4 font-semibold text-navy">Details</h3>
        <div className="divide-y divide-border-light">
          <InfoRow label="Due Date" value={cheque.due_date} highlight={cheque.is_overdue} />
          <InfoRow label="Bank" value={cheque.bank_name} />
          <InfoRow label="Branch" value={cheque.bank_branch || '—'} />
          <InfoRow label="Cheque Number" value={cheque.cheque_number} />
          <InfoRow label="Payee" value={cheque.payee_name || '—'} />
          <InfoRow label="Tenant" value={cheque.tenant_name || '—'} />
          <InfoRow label="Unit" value={cheque.unit_number || '—'} />
          <InfoRow label="Sequence" value={`#${cheque.sequence_number}`} />
          {cheque.notes && <InfoRow label="Notes" value={cheque.notes} />}
        </div>
      </div>

      {/* Status timeline */}
      {cheque.status_logs && cheque.status_logs.length > 0 && (
        <div className="rounded-2xl border border-border-light bg-white p-6">
          <h3 className="mb-4 font-semibold text-navy">Status History</h3>
          <div className="space-y-4">
            {cheque.status_logs.map((log) => (
              <div key={log.id} className="flex gap-4">
                <div className="flex flex-col items-center">
                  <div className="h-3 w-3 rounded-full bg-teal" />
                  <div className="w-px flex-1 bg-border-light" />
                </div>
                <div className="pb-4">
                  <div className="flex items-center gap-2">
                    <StatusBadge status={log.from_status} />
                    <span className="text-xs text-text-muted">→</span>
                    <StatusBadge status={log.to_status} />
                  </div>
                  <p className="mt-1 text-xs text-text-muted">
                    {log.changed_by_name || 'System'} · {new Date(log.created_at).toLocaleDateString()}
                  </p>
                  {log.notes && (
                    <p className="mt-1 text-sm text-text-secondary">{log.notes}</p>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Actions */}
      {(canDeposit || canClear || canBounce) && (
        <div className="flex gap-3">
          {canDeposit && (
            <button
              onClick={() => deposit.mutate({ id: cheque.id })}
              disabled={deposit.isPending}
              className="rounded-xl bg-teal px-6 py-3 text-sm font-bold text-white transition-colors hover:bg-teal-dark disabled:opacity-60"
            >
              {deposit.isPending ? 'Processing...' : 'Mark as Deposited'}
            </button>
          )}
          {canClear && (
            <button
              onClick={() => clear.mutate({ id: cheque.id })}
              disabled={clear.isPending}
              className="rounded-xl bg-success px-6 py-3 text-sm font-bold text-white transition-colors hover:opacity-90 disabled:opacity-60"
            >
              {clear.isPending ? 'Processing...' : 'Mark as Cleared'}
            </button>
          )}
          {canBounce && (
            <button
              onClick={() => bounce.mutate({ id: cheque.id, reason: 'Insufficient funds' })}
              disabled={bounce.isPending}
              className="rounded-xl bg-error px-6 py-3 text-sm font-bold text-white transition-colors hover:opacity-90 disabled:opacity-60"
            >
              {bounce.isPending ? 'Processing...' : 'Mark as Bounced'}
            </button>
          )}
        </div>
      )}
    </div>
  );
}

function InfoRow({ label, value, highlight }: { label: string; value: string; highlight?: boolean }) {
  return (
    <div className="flex items-center justify-between py-3">
      <span className="text-sm text-text-secondary">{label}</span>
      <span className={`text-sm font-medium ${highlight ? 'text-error' : 'text-text-primary'}`}>
        {value}
      </span>
    </div>
  );
}
