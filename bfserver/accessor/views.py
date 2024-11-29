from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.core.exceptions import ValidationError

from .models import Exercise

# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the accessor index.")

class Exercises:

    FILTER_KEYS = ["id", "name", "name__startswith", "type", "group", "equipment", "level", "mechanics"]

    def all(request):
        queryset = Exercise.objects.all()

        data = list(queryset)
        return JsonResponse(data, safe=False)

    def get (request):
        try:
            filters = {key: request.GET[key] for key in Exercises.FILTER_KEYS if key in request.GET}

            if not filters: return JsonResponse({"error": "No valid filters provided"}, status=400)

            queryset = Exercise.objects.filter(**filters).values()
            data = list(queryset)
            
            if not data: return JsonResponse({"error": "No results found"}, status=404)
            return JsonResponse(data, safe=False)
        except ValidationError as e:
            return JsonResponse({"error": str(e)}, status=400)    
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)


def user_data(request):
    return HttpResponse("Hello, world. You're at the user_data table accessor.")