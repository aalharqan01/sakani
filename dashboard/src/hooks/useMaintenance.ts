import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { maintenanceApi } from '../api/maintenance.api';

export function useMaintenanceRequests(params?: Record<string, string>) {
  return useQuery({
    queryKey: ['maintenance', 'list', params],
    queryFn: () => maintenanceApi.list(params),
  });
}

export function useMaintenanceDetail(id: string) {
  return useQuery({
    queryKey: ['maintenance', id],
    queryFn: () => maintenanceApi.detail(id),
    enabled: !!id,
  });
}

export function useMaintenanceCategories() {
  return useQuery({
    queryKey: ['maintenance', 'categories'],
    queryFn: maintenanceApi.categories,
  });
}

export function useCompleteMaintenance() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, notes }: { id: string; notes?: string }) =>
      maintenanceApi.complete(id, notes),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['maintenance'] });
    },
  });
}

export function useSubmitQuote() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, amount, description }: { id: string; amount: string; description: string }) =>
      maintenanceApi.submitQuote(id, amount, description),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['maintenance'] });
    },
  });
}
