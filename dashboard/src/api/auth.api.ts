import apiClient from './axios-client';
import type { User } from '../lib/types';

interface LoginResponse {
  access: string;
  refresh: string;
  user: User;
}

export const authApi = {
  login: async (phone_number: string, password: string): Promise<LoginResponse> => {
    const { data } = await apiClient.post('/auth/login/', { phone_number, password });
    return data;
  },

  getProfile: async (): Promise<User> => {
    const { data } = await apiClient.get('/auth/profile/');
    return data;
  },

  logout: async (refresh: string): Promise<void> => {
    await apiClient.post('/auth/logout/', { refresh });
  },

  changePassword: async (old_password: string, new_password: string): Promise<void> => {
    await apiClient.post('/auth/change-password/', { old_password, new_password });
  },
};
