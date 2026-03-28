#define _POSIX_C_SOURCE 200809L

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>

#include "config.h"
#include "output.h"
#include "tedit.h"

static bool editorParseBool(const char *value, bool *result)
{
	if (strcasecmp(value, "true") == 0 || strcmp(value, "1") == 0 ||
		strcasecmp(value, "yes") == 0 || strcasecmp(value, "on") == 0) {
		*result = true;
		return true;
	}

	if (strcasecmp(value, "false") == 0 || strcmp(value, "0") == 0 ||
		strcasecmp(value, "no") == 0 || strcasecmp(value, "off") == 0) {
		*result = false;
		return true;
	}

	return false;
}

static char *editorTrim(char *text)
{
	while (*text != '\0' && isspace((unsigned char)*text)) {
		text++;
	}

	char *end = text + strlen(text);
	while (end > text && isspace((unsigned char)end[-1])) {
		end--;
	}
	*end = '\0';
	return text;
}

static char *editorBuildConfigPath(const char *base_dir, const char *suffix)
{
	const size_t len = strlen(base_dir) + strlen(suffix) + 1;
	char *path = malloc(len);

	if (path == NULL) {
		return NULL;
	}

	snprintf(path, len, "%s%s", base_dir, suffix);
	return path;
}

static char *editorResolveConfigPath(void)
{
	const char *xdg_config = getenv("XDG_CONFIG_HOME");
	if (xdg_config != NULL && xdg_config[0] != '\0') {
		char *path = editorBuildConfigPath(xdg_config, "/tedit/config");
		if (path != NULL && access(path, F_OK) == 0) {
			return path;
		}
		free(path);
	}

	const char *home = getenv("HOME");
	if (home == NULL || home[0] == '\0') {
		return NULL;
	}

	char *path = editorBuildConfigPath(home, "/.config/tedit/config");
	if (path != NULL && access(path, F_OK) == 0) {
		return path;
	}
	free(path);

	return editorBuildConfigPath(home, "/.teditrc");
}

static void editorApplyIntSetting(const char *key, const char *value)
{
	char *end = NULL;
	errno = 0;
	const long parsed = strtol(value, &end, 10);

	if (errno != 0 || end == value || *end != '\0') {
		editorSetStatusMessage("Ignoring invalid config value for %s", key);
		return;
	}

	if (strcmp(key, "tab_stop") == 0) {
		if (parsed < 1 || parsed > 16) {
			editorSetStatusMessage("tab_stop must be between 1 and 16");
			return;
		}
		E.settings.tab_stop = (int)parsed;
	} else if (strcmp(key, "quit_confirmations") == 0) {
		if (parsed < 0 || parsed > 10) {
			editorSetStatusMessage("quit_confirmations must be between 0 and 10");
			return;
		}
		E.settings.quit_confirmations = (int)parsed;
	} else if (strcmp(key, "open_confirmations") == 0) {
		if (parsed < 0 || parsed > 10) {
			editorSetStatusMessage("open_confirmations must be between 0 and 10");
			return;
		}
		E.settings.open_confirmations = (int)parsed;
	}
}

static void editorApplyBoolSetting(const char *key, const char *value)
{
	bool parsed = false;

	if (!editorParseBool(value, &parsed)) {
		editorSetStatusMessage("Ignoring invalid config value for %s", key);
		return;
	}

	if (strcmp(key, "show_line_numbers") == 0) {
		E.settings.show_line_numbers = parsed;
	} else if (strcmp(key, "soft_wrap") == 0) {
		E.settings.soft_wrap = parsed;
	} else if (strcmp(key, "soft_indent") == 0) {
		E.settings.soft_indent = parsed;
	} else if (strcmp(key, "auto_indent") == 0) {
		E.settings.auto_indent = parsed;
	}
}

static void editorApplyConfigLine(char *line)
{
	char *trimmed = editorTrim(line);

	if (trimmed[0] == '\0' || trimmed[0] == '#') {
		return;
	}

	char *separator = strchr(trimmed, '=');
	if (separator == NULL) {
		return;
	}

	*separator = '\0';
	char *key = editorTrim(trimmed);
	char *value = editorTrim(separator + 1);

	if (strcmp(key, "tab_stop") == 0 || strcmp(key, "quit_confirmations") == 0 ||
		strcmp(key, "open_confirmations") == 0) {
		editorApplyIntSetting(key, value);
		return;
	}

	if (strcmp(key, "show_line_numbers") == 0 ||
		strcmp(key, "soft_wrap") == 0 ||
		strcmp(key, "soft_indent") == 0 ||
		strcmp(key, "auto_indent") == 0) {
		editorApplyBoolSetting(key, value);
	}
}

void editorLoadConfig(void)
{
	char *path = editorResolveConfigPath();
	if (path == NULL) {
		return;
	}

	FILE *config = fopen(path, "r");
	free(path);

	if (config == NULL) {
		return;
	}

	char *line = NULL;
	size_t capacity = 0;

	while (getline(&line, &capacity, config) != -1) {
		editorApplyConfigLine(line);
	}

	free(line);
	fclose(config);
}
