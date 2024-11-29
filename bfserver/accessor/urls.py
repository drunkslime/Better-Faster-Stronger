from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),

    path('exercises/', views.Exercises.get, name='exercises'),
    path('exercises/all/', views.Exercises.all, name='exercises_all'),

    path('user_data/', views.user_data, name='user_data'),
]