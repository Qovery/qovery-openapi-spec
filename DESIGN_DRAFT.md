# This is a design draft document

## SQL schema draft

```sql
CREATE TABLE _user
(
    id UUID PRIMARY KEY
);

CREATE TABLE organization
(
    id       UUID PRIMARY KEY,
    owner_id UUID NOT NULL REFERENCES _user (id),
);

CREATE TABLE project
(
    id              UUID PRIMARY KEY,
    created_at      TIMESTAMP NOT NULL DEFAULT now(),
    organization_id UUID      NOT NULL REFERENCES organization (id),
    owner_id        UUID      NOT NULL REFERENCES _user (id),
);

CREATE TABLE environment
(
    id         UUID PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    project_id UUID      NOT NULL REFERENCES project (id),
    owner_id   UUID REFERENCES _user (id),
);

CREATE TABLE environment_deployment -- store environment deployments
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE environment_event -- store environment events
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE application
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE application_deployment -- store app deployments
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    application_id UUID      NOT NULL REFERENCES application (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE application_event -- store app events
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    application_id UUID      NOT NULL REFERENCES application (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE _database
(
    id             UUID PRIMARY KEY,
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    environment_id UUID      NOT NULL REFERENCES environment (id),
    owner_id       UUID REFERENCES _user (id),
);

CREATE TABLE database_deployment -- store database deployments
(
    id          UUID PRIMARY KEY,
    created_at  TIMESTAMP NOT NULL DEFAULT now(),
    database_id UUID      NOT NULL REFERENCES _database (id),
    owner_id    UUID REFERENCES _user (id),
);

CREATE TABLE database_event -- store database events
(
    id          UUID PRIMARY KEY,
    created_at  TIMESTAMP NOT NULL DEFAULT now(),
    database_id UUID      NOT NULL REFERENCES _database (id),
    owner_id    UUID REFERENCES _user (id),
);
```

## Application

### list applications

GET /environment/:id/application

> This is partial info to add to the application

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
  "instances": [
    {
      "instance_id": "uuid",
      "cpu": {
        "requested_in_float": 4.0,
        "consumed_in_float": 2.4,
        "consumed_in_percent": 60.0,
        "warning_threshold_in_percent": 80,
        "alert_threshold_in_percent": 95,
        "status": {
          "state": "OK|WARNING|ERROR",
          "simple_state": "OK|WARNING|ERROR",
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
          "state": "OK|WARNING|ERROR",
          "simple_state": "OK|WARNING|ERROR",
          "message(nullable)": "can be null"
        }
      },
      "storage(nullable)": {
        "requested_in_gb": 20,
        "consumed_in_gb": 8,
        "consumed_in_percent": 40.0,
        "warning_threshold_in_percent": 80,
        "alert_threshold_in_percent": 90,
        "status": {
          "state": "OK|WARNING|ERROR",
          "simple_state": "OK|WARNING|ERROR",
          "message(nullable)": "can be null"
        }
      }
    }
  ],
  "instance": {
    "min": 0,
    "max": 8,
    "running": 3,
    "running_in_percent": 37.5,
    "warning_threshold_in_percent": 80,
    "alert_threshold_in_percent": 90,
    "status": {
      "state": "OK|WARNING|ERROR",
      "simple_state": "OK|WARNING|ERROR",
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
      "data": [
        {
          "created_at": "2021-03-20T09:01:28.103Z",
          "value": 2.3
        }
      ]
    },
    {
      "instance_name": "instance 2",
      "data": [
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

### get current application status

GET /application/:id/status

```json
{
  "status": {
    "state": "BUILDING_ERROR",
    "simple_state": "OK|WARNING|ERROR",
    "message": "Java.xxxx.yyyy not found"
  }
}
```

### get current application logs

#### list last 20 logs

GET /application/:id/log

#### list last 50 logs

GET /application/:id/log?tail=50

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
        "state": "DEPLOYING|...",
        "simple_state": "OK|WARNING|ERROR",
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
      },
      "message(nullable)": "log message",
      "message_human_explanation(nullable)": "explain what the error means -- Markdown can be injected",
      "hint(nullable)": "give a possible action to the user -- Markdown can be injected"
    }
  ]
}
```

#### list last logs from lastId

GET /application/:id/log?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYING|...",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "message(nullable)": "log message",
      "message_human_explanation(nullable)": "explain what the error means -- Markdown can be injected",
      "hint(nullable)": "give a possible action to the user -- Markdown can be injected"
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
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION",
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
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION",
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

### list app deployments

GET /application/:id/deployment?tail=50

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
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
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

#### list last app deployments from the lastId

GET /application/:id/deployment?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
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

### rollback a complete environment

POST /environment/:envId/deployment/:id/rollback

### abort deployment task

POST /environment/:envId/deployment/:id/abortDeploy

## Environment variable

### list application environment variables

GET /application/:id/environmentVariable

```json
{
  "results": [
    {
      "id": "uuid",
      "key": "KEY_1",
      "value": "VALUE_1",
      "scope": "BUILT_IN|ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION"
    }
  ]
}
```

Same for:

* GET /organization/:id/environmentVariable
* GET /project/:id/environmentVariable
* GET /environment/:id/environmentVariable

### create environment variable

POST /application/:id/environmentVariable

```json
{
  "key": "KEY_1",
  "value": "VALUE_1",
  "scope": "ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION"
}
```

Same for:

* POST /organization/:id/environmentVariable
* POST /project/:id/environmentVariable
* POST /environment/:id/environmentVariable

### delete environment variable

DELETE /environmentVariable/:id

## Secret

### list application secrets

GET /application/:id/secret

```json
{
  "results": [
    {
      "id": "uuid",
      "key": "KEY_1",
      "scope": "BUILT_IN|ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION",
      "description": "string"
    }
  ]
}
```

Same for:

* GET /organization/:id/secret
* GET /project/:id/secret
* GET /environment/:id/secret

### create secret

POST /application/:id/secret

```json
{
  "key": "KEY_1",
  "value": "VALUE_1",
  "scope": "ORGANIZATION|PROJECT|ENVIRONMENT|APPLICATION",
  "description": "string"
}
```

Same for:

* POST /organization/:id/secret
* POST /project/:id/secret
* POST /environment/:id/secret

### delete environment variable

DELETE /environmentVariable/:id

## Environment

### list environments

GET /project/:id/environment

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "updated_at": "2021-03-20T09:01:28.103Z",
      "name": "string",
      "status": {
        "state": "OK|WARNING|ERROR",
        "message(nullable)": "app 1 is down"
      },
      "last_updater": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "cloud_provider": {
        "id": "uuid",
        "name": "Amazon Web Services",
        "short_name": "AWS",
        "logo_url": "https://..."
      },
      "total_services": 18,
      "archived": "false"
    }
  ]
}
```

#### list archived environments

GET /project/:id/environment?archived=true

> An archived environment can't be started

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "updated_at": "2021-03-20T09:01:28.103Z",
      "name": "string",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message(nullable)": "app 1 is down"
      },
      "last_updater": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "cloud_provider": {
        "name": "Amazon Web Services",
        "short_name": "AWS",
        "logo_url": "https://..."
      },
      "total_services": 18,
      "archived": "true"
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

### get environment events

#### list last 20 events

GET /environment/:id/event

#### list last 50 events

GET /environment/:id/event?tail=50

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
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION|DATABASE|JOB|EXTERNAL_SERVICE",
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

GET /environment/:id/event?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "OK|WARNING|ERROR",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
      },
      "service": {
        "type": "APPLICATION|DATABASE|JOB|EXTERNAL_SERVICE",
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

## Deployment

### list environment deployments

GET /environment/:id/deployment?tail=50

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
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
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

#### list last environment deployments from the lastId

GET /environment/:id/deployment?lastId=xxx

```json
{
  "results": [
    {
      "id": "uuid",
      "created_at": "2021-03-20T09:01:28.103Z",
      "status": {
        "state": "DEPLOYMENT_IN_PROGRESS|OK|FAILED",
        "simple_state": "OK|WARNING|ERROR",
        "message": "Deployment is in progress"
      },
      "owner(nullable)": {
        "id": "uuid",
        "name": "Firstname Lastname",
        "picture_profile_url": "uri"
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

### rollback a complete environment

POST /environment/:envId/deployment/:id/rollback

### abort environment deployment task

POST /environment/:envId/deployment/:id/abortDeploy
