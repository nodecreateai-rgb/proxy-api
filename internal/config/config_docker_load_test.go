package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestDockerConfigLoadsAsV8(t *testing.T) {
	data, err := os.ReadFile(filepath.Join("..", "..", "config.docker.yaml"))
	if err != nil {
		t.Fatal(err)
	}
	cfg, err := ParseConfigBytes(data)
	if err != nil {
		t.Fatalf("load docker v8 config: %v", err)
	}
	if err = ValidateV8Config(data); err != nil {
		t.Fatalf("docker config must use the v8 layout: %v", err)
	}
	if cfg.Host != "0.0.0.0" || cfg.Port != 8317 || !cfg.RemoteManagement.AllowRemote {
		t.Fatalf("docker listener/management defaults were lost: host=%q port=%d allowRemote=%v", cfg.Host, cfg.Port, cfg.RemoteManagement.AllowRemote)
	}
	if len(cfg.OpenAICompatibility) == 0 {
		t.Fatal("docker blink openai-compatibility provider is missing")
	}
}
