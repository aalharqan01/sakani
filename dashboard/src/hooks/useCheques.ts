import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { chequesApi } from '../api/cheques.api';

export function useChequeDashboard() {
  return useQuery({
    queryKey: ['cheques', 'dashboard'],
    queryFn: chequesApi.dashboard,
  });
}

export function useCheques(params?: Record<string, string>) {
  return useQuery({
    queryKey: ['cheques', 'list', params],
    queryFn: () => chequesApi.list(params),
  });
}

export function useChequeDetail(id: string) {
  return useQuery({
    queryKey: ['cheques', id],
    queryFn: () => chequesApi.detail(id),
    enabled: !!id,
  });
}

export function useUpcomingCheques() {
  return useQuery({
    queryKey: ['cheques', 'upcoming'],
    queryFn: chequesApi.upcoming,
  });
}

export function useOverdueCheques() {
  return useQuery({
    queryKey: ['cheques', 'overdue'],
    queryFn: chequesApi.overdue,
  });
}

export function useDepositCheque() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, notes }: { id: string; notes?: string }) => chequesApi.deposit(id, notes),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['cheques'] });
    },
  });
}

export function useClearCheque() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, notes }: { id: string; notes?: string }) => chequesApi.clear(id, notes),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['cheques'] });
    },
  });
}

export function useBounceCheque() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, reason, notes }: { id: string; reason: string; notes?: string }) =>
      chequesApi.bounce(id, reason, notes),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['cheques'] });
    },
  });
}
