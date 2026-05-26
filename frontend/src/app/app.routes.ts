import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { GestorComponent } from './pages/gestor/gestor.component';
import { ClientDashboardComponent } from './pages/client-dashboard/client-dashboard.component';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'gestor', component: GestorComponent, pathMatch: 'full' },
  {
    path: 'clienteDashboard',
    component: ClientDashboardComponent,
  },
  { path: '**', component: HomeComponent },
];
