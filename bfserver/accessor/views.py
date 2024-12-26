from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.core.exceptions import ValidationError

from .models import Exercise
from .models import Account
from django.contrib.auth.models import User

# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the accessor index.")

class ExerciseData:

    FILTER_KEYS = ["id", "name", "name__startswith", "type", "group", "equipment", "level", "mechanics"]

    def getAll(request):
        queryset = Exercise.objects.all()

        data = list(queryset)
        return JsonResponse(data, safe=False)

    def get (request):
        try:
            filters = {key: request.GET[key] for key in ExerciseData.FILTER_KEYS if key in request.GET}

            if not filters: return JsonResponse({"error": "No valid filters provided"}, status=400)

            queryset = Exercise.objects.filter(**filters).values()
            data = list(queryset)
            
            if not data: return JsonResponse({"error": "No results found"}, status=404)
            return JsonResponse(data, safe=False)
        except ValidationError as e:
            return JsonResponse({"error": str(e)}, status=400)    
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)

class Accounts:

    def getAllAccounts(request):
        return JsonResponse(list(Account.objects.all().values()), safe=False)
    
    def getAllUsers(request):
        return JsonResponse(list(User.objects.all().values()), safe=False)    

    # Check the existance of user during authentification
    def userExists(request):
        try:
            queryset = User.objects.filter(username=request.GET['username'])
            if not queryset: return HttpResponse(status=404)
            return HttpResponse(status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)

    # Send if user exists
    def getUserAccount(request): 
        return JsonResponse(list(Account.objects.filter(userRef__username=request.GET['username']).values()), safe=False)

    def createNewUser(request):
        try:
            User.objects.create_user(username=request.GET['username'], password=request.GET['password'])
            return JsonResponse({'message': 'Success'}, safe=False)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)

    def createNewAccount(request):
        try:
            user = User.objects.get(username=request.GET['username'])
            Account.objects.create(userRef=user, name=request.GET['name'], sex=request.GET['sex'], age=request.GET['age'], weight=request.GET['weight'], height=request.GET['height'])
            return JsonResponse({'message': 'Success'}, safe=False)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    def authUser(request):
        try:
            if Accounts.userExists(request) == 404: return JsonResponse({'message': 'User not found'}, status=404)
            user = User.objects.get(username=request.GET['username'])
            if not user.check_password(request.GET['password']): 
                return JsonResponse({'message': 'Wrong password'}, status=401)
            return HttpResponse(status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    def registerUser(request):
        try:
            if Accounts.userExists(request) == 200: return JsonResponse({'message': 'User already exists'}, status=400)
            Accounts.createNewUser(request)
            Accounts.createNewAccount(request)
            return HttpResponse(status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        

