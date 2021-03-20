## This is a design draft document

### list applications

GET /environment/:id/application

```json
{
  "results": [
    {
      "flags": [
        "GIT_CONNECTION_ERROR",
        "UPDATE_AVAILABLE",
        "XXX"
      ]
    }
  ]
}
```

### get application instant metrics

GET /application/:id/instantMetric

```json
{
  "cpu": {
    "requested_in_float": 4.0,
    "consumed_in_float": 2.4,
    "consumed_in_percent": 60.0,
    "warning_threshold_in_percent": 80,
    "alert_threshold_in_percent": 95,
    "status": {
      "state": "OK|WARNING|ALERT",
      "message(nullable)": "can be null"
    }
  },
  "memory": {
    "requested_in_mb": 4096,
    "consumed_in_mb": 3255,
    "consumed_in_percent": 79.6,
    "warning_threshold_in_percent": 80,
    "alert_threshold_in_percent": 95,
    "status": {
      "state": "OK|WARNING|ALERT",
      "message(nullable)": "can be null"
    }
  },
  "storage(optional)": {
    "requested_in_gb": 20,
    "consumed_in_gb": 8,
    "consumed_in_percent": 40.0,
    "warning_threshold_in_percent": 80,
    "alert_threshold_in_percent": 90,
    "status": {
      "state": "OK|WARNING|ALERT",
      "message(nullable)": "can be null"
    }
  },
  "instance": {
    "min": 0,
    "max": 8,
    "running": 3,
    "running_in_percent": 37.5,
    "warning_threshold_in_percent": 80,
    "alert_threshold_in_percent": 90,
    "status": {
      "state": "OK|WARNING|ALERT",
      "message(nullable)": "can be null"
    }
  }
}
```

### get application metrics over time

#### CPU metrics

GET /application/:id/metric/cpu?lastDays=30

```json
{
  "results": [
    {
      "instance_name": "instance 1",
      "data_points": [
        {
          "created_at": "2021-03-20T09:01:28.103Z",
          "value": 2.3
        }
      ]
    },
    {
      "instance_name": "instance 2",
      "data_points": [
        {
          "created_at": "2021-03-20T09:01:28.103Z",
          "value": 0.8
        }
      ]
    }
  ]
}
```

same for:

* GET /application/:id/metric/memory?lastDays=30
* GET /application/:id/metric/healthCheck?lastDays=30
* GET /application/:id/metric/storage?lastDays=30
* GET /application/:id/metric/instance?lastDays=30

### get application status

GET /application/:id/status

```json
{
  "status": {
    "state": "BUILDING_ERROR",
    "message": "Java.xxxx.yyyy not found"
  }
}
```

### get application logs

GET /application/:id/log

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "message": "Deployment is in progress"
      },
      "owner": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

### get application events

#### list last 20 events

GET /application/:id/event

#### list last 50 events

GET /application/:id/event?tail=50

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION|DATABASE",
        "id": "uuid",
        "name": "string"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

#### list last events from the lastId

GET /application/:id/event?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION|DATABASE",
        "id": "uuid",
        "name": "string"
      },
      "commit(nullable)": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

### clone environment

POST /environment/:id/clone

```json
{
  "name": "new env name",
  "mode": "DEVELOPMENT"
}
```

### list deployments

GET /environment/:id/deployment

```json
{
  "page": 1,
  "page_size": 20,
  "total": 100,
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "message": "Deployment is in progress"
      },
      "owner": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "commit": {
        "short_id": "string",
        "long_id": "string",
        "message": "fix: xxxxxxxxxxx"
      }
    }
  ]
}
```

### rollback an environment

POST /environment/:id/deployment/:deploymentId/rollback

### abort deployment task

POST /deployment/:id/abortDeploy
