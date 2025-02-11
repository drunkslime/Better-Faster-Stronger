from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.core.exceptions import ValidationError

from .models import Exercise, Account, Workout
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
import json



# Create your views here.
def index(request):
    return HttpResponse("Hello, world. You're at the accessor index.")

class ExerciseData:

    FILTER_KEYS = ["id", "name", "name__startswith", "type", "group", "equipment", "level", "mechanics"]

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
    
    def getAll(request):
        queryset = Exercise.objects.all().values()

        data = list(queryset)
        return JsonResponse(data, safe=False)

class Accounts:

    def getAllAccounts(request):
        return JsonResponse(list(Account.objects.all().values()), safe=False)
    
    def getAllUsers(request):
        return JsonResponse(list(User.objects.all().values()), safe=False)    

    # Check the existance of user
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
        return JsonResponse(list(Account.objects.filter(userRef__username=request.GET['username']).values())[0], safe=False)
    
    def getUserAccountById(request):
        return JsonResponse(list(Account.objects.filter(id=request.GET['id']).values())[0], safe=False)

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
            accountData = Account.objects.filter(userRef__username=user.username).values()[0]
            return JsonResponse(accountData, safe=False)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    def authUser(request):
        try:
            if Accounts.userExists(request) == 404: return JsonResponse({'message': 'User not found'}, status=404)
            user = authenticate(username=request.GET['username'], password=request.GET['password'])
            if user is None: 
                return JsonResponse({'message': 'Wrong credentials'}, status=401)
            accountData = Account.objects.filter(userRef__username=user.username).values()[0]
            return JsonResponse(accountData, safe=False, status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    def registerUser(request):
        try:
            if Accounts.userExists(request).status_code == 200: return JsonResponse({'message': 'User already exists'}, status=400)
            Accounts.createNewUser(request)
            accountData = Accounts.createNewAccount(request)
            return JsonResponse(json.loads(accountData.content.decode('utf-8')), safe=False, status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        

    def addWorkout(request):
        try:
            account = Account.objects.get(id=request.GET['id'])
            workout = Workout.objects.create(accountRef=account)
            workout.save()
            account.workouts.append(
                {
                    "id": workout.id,
                    "name": request.GET['name'],
                    "description": request.GET['description']
                }
            )
            account.save()
            return HttpResponse("Workout added")
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)