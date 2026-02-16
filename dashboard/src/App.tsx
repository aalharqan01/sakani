import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { AuthProvider } from './auth/AuthContext';
import ProtectedRoute from './auth/ProtectedRoute';
import DashboardLayout from './components/layout/DashboardLayout';
import LoginPage from './pages/LoginPage';
import DashboardPage from './pages/DashboardPage';
import ChequeListPage from './pages/cheques/ChequeListPage';
import ChequeDetailPage from './pages/cheques/ChequeDetailPage';
import CompoundListPage from './pages/compounds/CompoundListPage';
import LeaseListPage from './pages/leases/LeaseListPage';
import MaintenanceListPage from './pages/maintenance/MaintenanceListPage';
import MaintenanceDetailPage from './pages/maintenance/MaintenanceDetailPage';
import TenantListPage from './pages/tenants/TenantListPage';
import UnitListPage from './pages/units/UnitListPage';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      retry: 1,
    },
  },
});

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <BrowserRouter>
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route element={<ProtectedRoute />}>
              <Route element={<DashboardLayout />}>
                <Route index element={<DashboardPage />} />
                <Route path="cheques" element={<ChequeListPage />} />
                <Route path="cheques/:id" element={<ChequeDetailPage />} />
                <Route path="compounds" element={<CompoundListPage />} />
                <Route path="leases" element={<LeaseListPage />} />
                <Route path="tenants" element={<TenantListPage />} />
                <Route path="maintenance" element={<MaintenanceListPage />} />
                <Route path="maintenance/:id" element={<MaintenanceDetailPage />} />
                <Route path="units" element={<UnitListPage />} />
              </Route>
            </Route>
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </QueryClientProvider>
  );
}
