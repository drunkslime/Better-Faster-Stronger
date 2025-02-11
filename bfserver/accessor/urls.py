from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),

    path('exercises/', views.ExerciseData.get, name='exercises'),
    path('exercises/getAll/', views.ExerciseData.getAll, name='exercises_all'),

    path('accounts/getUsers', views.Accounts.getAllUsers, name='get_all_users'),
    path('accounts/getAccounts', views.Accounts.getAllAccounts, name='get_all_accounts'),
    path('accounts/getUserAccount', views.Accounts.getUserAccountById, name='get_user_account'),        
    path('accounts/authUser', views.Accounts.authUser, name='auth_user'),        
    path('accounts/registerUser', views.Accounts.registerUser, name='register_user'),
    path('accounts/addWorkout', views.Accounts.addWorkout, name='add_workout'), # (int) id, (str) name, (str) description     
]