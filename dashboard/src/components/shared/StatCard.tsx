interface StatCardProps {
  label: string;
  value: string | number;
  icon?: React.ReactNode;
  trend?: string;
  trendUp?: boolean;
  className?: string;
}

export default function StatCard({ label, value, icon, trend, trendUp, className = '' }: StatCardProps) {
  return (
    <div className={`rounded-2xl border border-border-light bg-white p-5 ${className}`}>
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm font-medium text-text-secondary">{label}</p>
          <p className="mt-1 text-2xl font-bold text-text-primary">{value}</p>
          {trend && (
            <p className={`mt-1 text-xs font-medium ${trendUp ? 'text-success' : 'text-error'}`}>
              {trendUp ? '↑' : '↓'} {trend}
            </p>
          )}
        </div>
        {icon && (
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-teal-surface text-teal">
            {icon}
          </div>
        )}
      </div>
    </div>
  );
}
