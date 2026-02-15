import apiClient from './axios-client';
import type { MaintenanceRequest, PaginatedResponse } from '../lib/types';

export const maintenanceApi = {
  list: async (params?: Record<string, string>): Promise<PaginatedResponse<MaintenanceRequest>> => {
    const { data } = await apiClient.get('/maintenance/requests/', { params });
    return data;
  },

  detail: async (id: string): Promise<MaintenanceRequest> => {
    const { data } = await apiClient.get(`/maintenance/requests/${id}/`);
    return data;
  },

  categories: async () => {
    const { data } = await apiClient.get('/maintenance/categories/');
    return data;
  },

  complete: async (id: string, notes?: string): Promise<MaintenanceRequest> => {
    const { data } = await apiClient.post(`/maintenance/requests/${id}/complete/`, { notes });
    return data;
  },

  submitQuote: async (id: string, amount: string, description: string) => {
    const { data } = await apiClient.post(`/maintenance/requests/${id}/quote/`, {
      amount,
      description,
    });
    return data;
  },
};
