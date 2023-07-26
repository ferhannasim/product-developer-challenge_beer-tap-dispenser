# API Documentation

## localhost:3000/api/v1/users `(POST)`
### user register body parameter example
```
   {
    "user":{
        "email": "attendee4@example.com", 
        "password": "attendee_password",
        "role": "attendee"
        }                                       
    }
```

## localhost:3000/api/v1/login `(POST)`
`Retrive Auth token for authentication purpose`
```
    {
        "email": "admin@example.com", 
        "password": "admin_password"
    }
```

## localhost:3000/dispensers `(GET)`
`Add Authorization (Bearer Token) in your Postman`

## localhost:3000/dispensers `(POST)`
### Creating new Dispenser
`Add Authorization (Bearer Token) in your Postman`
```
{
    "dispenser": {
        "flow_volume": 3.56
    }
}
```

## localhost:3000/dispensers/1/tap_events `(POST)`
### Start Dispenser Tap
`Add Authorization (Bearer Token) in your Postman`

## localhost:3000/dispensers/1/tap_events/6 (PATCH)
### Stop Dispenser Tap
`Add Authorization (Bearer Token) in your Postman`

## localhost:3000/dispensers/usage_details `(GET)`
### Dispenser Usage Details

## localhost:3000/dispensers/4/tap_events/usage_details `(GET)`
### Specific Dispenser Usage
`Add Authorization (Bearer Token) in your Postman`