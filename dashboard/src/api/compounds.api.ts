import apiClient from './axios-client';
import type { Unit, PaginatedResponse } from '../lib/types';

export const compoundsApi = {
  list: async () => {
    const { data } = await apiClient.get('/compounds/');
    return data;
  },

  detail: async (id: string) => {
    const { data } = await apiClient.get(`/compounds/${id}/`);
    return data;
  },

  occupancy: async (id: string) => {
    const { data } = await apiClient.get(`/compounds/${id}/occupancy/`);
    return data;
  },
};

export const unitsApi = {
  list: async (params?: Record<string, string>): Promise<PaginatedResponse<Unit>> => {
    const { data } = await apiClient.get('/units/', { params });
    return data;
  },

  detail: async (id: string): Promise<Unit> => {
    const { data } = await apiClient.get(`/units/${id}/`);
    return data;
  },
};

export const leasesApi = {
  list: async (params?: Record<string, string>) => {
    const { data } = await apiClient.get('/leases/', { params });
    return data;
  },

  detail: async (id: string) => {
    const { data } = await apiClient.get(`/leases/${id}/`);
    return data;
  },

  activate: async (id: string) => {
    const { data } = await apiClient.post(`/leases/${id}/activate/`);
    return data;
  },

  terminate: async (id: string) => {
    const { data } = await apiClient.post(`/leases/${id}/terminate/`);
    return data;
  },
};
