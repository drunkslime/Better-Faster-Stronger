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
            user = User.objects.create_user(username=request.GET['username'], password=request.GET['password'])
            return user, JsonResponse({'message': 'Success'}, safe=False)
        except ValidationError as e:
            return None, JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return None, JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)

    def createNewAccount(request, user: User):
        try:
            account = Account.objects.create(
                userRef=user, 
                name=request.GET['name'], 
                sex=request.GET['sex'], 
                age=request.GET['age'], 
                weight=request.GET['weight'], 
                height=request.GET['height']
            )
            accountData = Account.objects.filter(userRef__username=user.username).values()[0]
            return JsonResponse(accountData, safe=False)
        except ValidationError as e:
            return JsonResponse({"error:": str(e), "error type": type(e)}, status=400)
        except Exception as e:
            user.delete()
            return JsonResponse({"error": "An error occurred", "error type": type(e), "details": str(e)}, status=500)
        
    def authUser(request):
        try:
            if Accounts.userExists(request).status_code == 404:
                return JsonResponse({'message': 'User not found'}, status=404)
            user = authenticate(username=request.GET['username'], password=request.GET['password'])
            if user is None: 
                return JsonResponse({'message': 'Wrong credentials'}, status=401)
            accountData = Account.objects.filter(userRef__username=user.username).values()[0]
            return JsonResponse(accountData, safe=False, status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e), "error type": type(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "error type": type(e), "details": str(e)}, status=500)
        

    def validateData(request):
        if (type(request.GET['age']) is not int):
            raise ValidationError('Age should be an integer.')
        if (type(request.GET['weight']) is not int):
            raise ValidationError('Weight should be an integer.')
        if (type(request.GET['height']) is not int):
            raise ValidationError('Height should be an integer.')
        if (type(request.GET['sets']) is not int):
            raise ValidationError('Number of sets should be an integer')
        if (type(request.GET['reps']) is not int):
            raise ValidationError('Number of reps should be an integer')
        if (type(request.GET['time']) is not int):
            raise ValidationError('Time should be an integer')
        if (request.GET['age'] <= 0 or request.GET['age'] >= 100):
            raise ValueError('The age should be a number between 0 and 100.')
        if (request.GET['weight'] <= 0 or request.GET['weight'] >= 1000):
            raise ValueError('The weight should be a number between 0 and 1000.')
        if (request.GET['height'] <= 0 or request.GET['height'] >= 300):
            raise ValueError('The height should be a number between 0 and 300')
        if (request.GET['sets'] <= 0 or request.GET['sets'] >= 99):
            raise ValueError('The sets value should be a number between 0 and 99')
        if (request.GET['reps'] <= 0 or request.GET['reps'] >= 999):
            raise ValueError('The reps should be a number between 0 and 999')
        if (request.GET['time'] <= 0 or request.GET['time'] >= 999):
            raise ValueError('The time value should be a number between 0 and 999')
        if (len(request.GET['username']) == 0 or len(request.GET['username']) >= 50):
            raise ValueError('The usernamename should be less than 50 characters and not empty.')
        if (len(request.GET['name']) == 0 or len(request.GET['name']) >= 100):
            raise ValueError('The name should be less than 100 characters and not empty.')

    def registerUser(request):
        try:
            if Accounts.userExists(request).status_code == 200:
                return JsonResponse({'message': 'User already exists'}, status=400)

            user, user_response = Accounts.createNewUser(request)
            if not user:
                return user_response
            
            account_response = Accounts.createNewAccount(request, user)
            if account_response.status_code != 200:
                return account_response
            
            return JsonResponse(json.loads(account_response.content.decode('utf-8')), safe=False, status=200)
        except ValidationError as e:
            return JsonResponse({"error:": str(e), "error type": type(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "error type": type(e), "details": str(e)}, status=500)
        

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
        

    def deleteWorkout(request):
        try:
            workout = Workout.objects.get(id=request.GET['id'])
            workout.accountRef.workouts.pop(int(request.GET['index']))
            workout.delete()
            workout.save()
            workout.accountRef.save()
            return HttpResponse("Workout removed")
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)

    def getWorkout(request):
        try:
            workout = Workout.objects.get(id=request.GET['id'])
            return JsonResponse(workout.exercises, safe=False)
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    
    def addExerciseToWorkout(request):
        try:
            isTime = 'time' in list(request.GET.keys())
            print(isTime)
            workout = Workout.objects.get(id=request.GET['workoutId'])
            exercise = Exercise.objects.get(id=request.GET['exerciseId'])

            if 'index' in list(request.GET.keys()) and request.GET['index'] != 'null':
                workout.exercises.insert(int(request.GET['index']), {
                    "id": exercise.id,
                    "Sets": request.GET['sets'],
                    f"{'Time' if isTime else 'Reps'}": request.GET[f'{"time" if isTime else "reps"}'],
                })
            else:
                workout.exercises.append({
                    "id": exercise.id,
                    "Sets": request.GET['sets'],
                    f"{'Time' if isTime else 'Reps'}": request.GET[f'{"time" if isTime else "reps"}'],
                })

            workout.save()
            return HttpResponse("Exercise added")
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    def removeExerciseFromWorkout(request):
        try:
            workout = Workout.objects.get(id=request.GET['workoutId'])
            workout.exercises.pop(int(request.GET['index']))
            workout.save()
            return HttpResponse("Exercise removed")
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        
    def reorderExerciseInWorkout(request):
        try:
            workout = Workout.objects.get(id=request.GET['workoutId'])
            exerciseCopy = workout.exercises[int(request.GET['oldIndex'])]
            workout.exercises.pop(int(request.GET['oldIndex']))
            workout.exercises.insert(int(request.GET['newIndex']), exerciseCopy)
            workout.save()
            return HttpResponse("Exercise reordered from " + request.GET['oldIndex'] + " to " + request.GET['newIndex'])
        except ValidationError as e:
            return JsonResponse({"error:": str(e)}, status=400)
        except Exception as e:
            return JsonResponse({"error": "An error occurred", "details": str(e)}, status=500)
        