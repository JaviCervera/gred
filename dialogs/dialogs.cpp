#include <stddef.h>
#include "sdk.h"
#include "strmanip.h"
#include "tinyfiledialogs.h"

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

typedef char bool_t;

ColdSteelSDK* sdk = 0;

extern "C" {

bool_t Confirm(const char* title, const char* text, bool_t serious) {
  return tinyfd_messageBox(title, text, "yesno", serious ? "error" : "question", 1) == 1;
}

void Notify(const char* title, const char* text, bool_t serious) {
  tinyfd_messageBox(title, text, "ok", serious ? "error" : "info", 0);
}

int Proceed(const char* title, const char* text, bool_t serious) {
  return tinyfd_messageBox(title, text, "yesnocancel", serious ? "error" : "question", 0);
}

int RequestColor(const char* title, int color) {
  unsigned char c[3];
  c[0] = (color >> 16) & 0xFF;
  c[1] = (color >> 8) & 0xFF;
  c[2] = color & 0xFF;
  
  if (tinyfd_colorChooser(title, NULL, c, c)) {
    color = (c[0] << 16) | (c[1] << 8) | c[2];
  }
  
  return color;
}

const char* RequestDir(const char* title, const char* dir) {
  const char* selDir = tinyfd_selectFolderDialog(title, dir);
  if (selDir != NULL) {
    return selDir;
  } else {
    return "";
  }
}

const char* RequestFile(const char* title, const char* filters, bool_t save, const char* file) {
  const char* fname = NULL;
  const char** pfilters = NULL;
  std::vector<std::string> split;
  if (filters && strcmp(filters, "") != 0) {
    split = swan::strmanip::split(filters, ',');
    pfilters = (const char**)malloc(sizeof(char*) * split.size());
    for (size_t i = 0; i < split.size(); ++i) {
      pfilters[i] = split[i].c_str();
    }
  }

  if (!save) {
    fname = tinyfd_openFileDialog(title, file, split.size(), pfilters, filters, 0);
  } else {
    fname = tinyfd_saveFileDialog(title, file, split.size(), pfilters, filters);
  }

  if (pfilters) free(pfilters);
  
  if (fname != NULL) {
    return fname;
  } else {
    return "";
  }
}

const char* RequestInput(const char* title, const char* text, const char* def, bool_t password) {
  const char* input = tinyfd_inputBox(title, text, password ? (const char*)NULL : def);
  if (input != NULL) {
    return input;
  } else {
    return "";
  }
}

int wrap_Confirm(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  const char* text = sdk->GetStringArg(context, 2);
  bool_t serious = sdk->GetBoolArg(context, 3);
  bool_t result = Confirm(title, text, serious);
  sdk->PushBool(context, result);
  return 1;
}

int wrap_Notify(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  const char* text = sdk->GetStringArg(context, 2);
  bool_t serious = sdk->GetBoolArg(context, 3);
  Notify(title, text, serious);
  return 0;
}

int wrap_Proceed(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  const char* text = sdk->GetStringArg(context, 2);
  bool_t serious = sdk->GetBoolArg(context, 3);
  int result = Proceed(title, text, serious);
  sdk->PushInt(context, result);
  return 1;
}

int wrap_RequestColor(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  int color = sdk->GetIntArg(context, 2);
  int result = RequestColor(title, color);
  sdk->PushInt(context, result);
  return 1;
}

int wrap_RequestDir(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  const char* dir = sdk->GetStringArg(context, 2);
  const char* result = RequestDir(title, dir);
  sdk->PushString(context, result);
  return 1;
}

int wrap_RequestFile(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  const char* filters = sdk->GetStringArg(context, 2);
  bool_t save = sdk->GetBoolArg(context, 3);
  const char* file = sdk->GetStringArg(context, 4);
  const char* result = RequestFile(title, filters, save, file);
  sdk->PushString(context, result);
  return 1;
}

int wrap_RequestInput(void* context) {
  const char* title = sdk->GetStringArg(context, 1);
  const char* text = sdk->GetStringArg(context, 2);
  const char* def = sdk->GetStringArg(context, 3);
  bool_t password = sdk->GetBoolArg(context, 4);
  const char* result = RequestInput(title, text, def, password);
  sdk->PushString(context, result);
  return 1;
}

EXPORT int dialogs_load(ColdSteelSDK* sdk_) {
  sdk = sdk_;
  sdk->RegisterFunction("Confirm", wrap_Confirm);
  sdk->RegisterFunction("Notify", wrap_Notify);
  sdk->RegisterFunction("Proceed", wrap_Proceed);
  sdk->RegisterFunction("RequestColor", wrap_RequestColor);
  sdk->RegisterFunction("RequestDir", wrap_RequestDir);
  sdk->RegisterFunction("RequestFile", wrap_RequestFile);
  sdk->RegisterFunction("RequestInput", wrap_RequestInput);
  return 1;
}

} // extern "C"
