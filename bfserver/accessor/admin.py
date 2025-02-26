from django.contrib import admin

from .models import Exercise
from .models import Account
from .models import Workout

# Register your models here.
admin.site.register(Exercise)
admin.site.register(Account)
admin.site.register(Workout)