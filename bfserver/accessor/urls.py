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
    path('accounts/deleteWorkout', views.Accounts.deleteWorkout, name='remove_workout'), # (int) id, (int) index
    path('accounts/getWorkout', views.Accounts.getWorkout, name='get_workout'), # (int) id
    path('accounts/addExerciseToWorkout', views.Accounts.addExerciseToWorkout, name='add_exercise_to_workout'), # (int) workoutId, (int) exerciseId, (int) sets, (int) reps/time
    path('accounts/removeExerciseFromWorkout', views.Accounts.removeExerciseFromWorkout, name='remove_exercise_from_workout'), # (int) workoutId, (int) index
    path('accounts/reorderExerciseInWorkout', views.Accounts.reorderExerciseInWorkout, name='reorder_exercise_in_workout'), # (int) workoutId, (int) oldIndex, (int) newIndex
]