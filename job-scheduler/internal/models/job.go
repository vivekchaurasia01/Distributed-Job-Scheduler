package models

import "time"

type JobStatus string  // To escape from typo error that compile normally but filed at runtime like(running != runng)...


const (
	StatusPending JobStatus = "pending"
	StatusRunning JobStatus = "running"
	StatusCompleted JobStatus = "completed"
	StatusFailed JobStatus = "failed"
	StatusDead JobStatus = "dead"
)

type Job struct {
	ID          int64
    Type        string  // what type of job is it...like send email etc.....
    Payload     []byte
    Status      JobStatus
    Priority    int
    MaxRetries  int
    RetryCount  int
	LockedUntil *time.Time
    RunAt       time.Time
    CreatedAt   time.Time
    UpdatedAt   time.Time
}