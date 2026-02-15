import apiClient from './axios-client';
import type { Cheque, ChequeDashboard, PaginatedResponse } from '../lib/types';

export const chequesApi = {
  list: async (params?: Record<string, string>): Promise<PaginatedResponse<Cheque>> => {
    const { data } = await apiClient.get('/cheques/', { params });
    return data;
  },

  detail: async (id: string): Promise<Cheque> => {
    const { data } = await apiClient.get(`/cheques/${id}/`);
    return data;
  },

  dashboard: async (): Promise<ChequeDashboard> => {
    const { data } = await apiClient.get('/cheques/dashboard/');
    return data;
  },

  upcoming: async (): Promise<Cheque[]> => {
    const { data } = await apiClient.get('/cheques/upcoming/');
    return data;
  },

  overdue: async (): Promise<Cheque[]> => {
    const { data } = await apiClient.get('/cheques/overdue/');
    return data;
  },

  deposit: async (id: string, notes?: string): Promise<Cheque> => {
    const { data } = await apiClient.post(`/cheques/${id}/deposit/`, { notes });
    return data;
  },

  clear: async (id: string, notes?: string): Promise<Cheque> => {
    const { data } = await apiClient.post(`/cheques/${id}/clear/`, { notes });
    return data;
  },

  bounce: async (id: string, reason: string, notes?: string): Promise<Cheque> => {
    const { data } = await apiClient.post(`/cheques/${id}/bounce/`, { bounce_reason: reason, notes });
    return data;
  },
};
