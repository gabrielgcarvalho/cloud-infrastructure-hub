package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerragruntExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir:    "../",
		TerraformBinary: "terraform",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.Apply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "public_ip")

	url := fmt.Sprintf("http://%s", publicIp)
	expectedStatusCode := 200

	// Define the custom validation function
	validateResponse := func(statusCode int, responseBody string) bool {
		return statusCode == expectedStatusCode
	}

	// Make an HTTP request and get the response with custom validation
	retries := 30
	sleepBetweenRetries := 5 * time.Second
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, retries, sleepBetweenRetries, validateResponse)
}
