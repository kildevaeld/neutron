#include <ctype.h>
#include <neutron/utils.h>
#include <stdlib.h>
#include <string.h>

/* Converts a hex character to its integer value */
char vv_utils_from_hex(char ch) {
  return isdigit(ch) ? ch - '0' : tolower(ch) - 'a' + 10;
}

/* Converts an integer value to its hex character*/
char vv_utils_to_hex(char code) {
  static char hex[] = "0123456789abcdef";
  return hex[code & 15];
}

void vv_utils_url_encode_into(char *buf, char *str) {
  char *pstr = str, *pbuf = buf;
  while (*pstr) {
    if (isalnum(*pstr) || *pstr == '-' || *pstr == '_' || *pstr == '.' ||
        *pstr == '~')
      *pbuf++ = *pstr;
    else if (*pstr == ' ') {
      //*pbuf++ = '+';
      *pbuf++ = '%';
      *pbuf++ = '2';
      *pbuf++ = '0';
    } else
      *pbuf++ = '%', *pbuf++ = vv_utils_to_hex(*pstr >> 4),
      *pbuf++ = vv_utils_to_hex(*pstr & 15);
    pstr++;
  }
  *pbuf = '\0';
}

char *vv_utils_url_encode(char *str) {
  char *buf = malloc(strlen(str) * 3 + 1);
  vv_utils_url_encode_into(buf, str);
  return buf;
}

/* Returns a url-decoded version of str */
/* IMPORTANT: be sure to free() the returned string after use */
char *vv_utils_url_decode(char *str) {
  char *pstr = str, *buf = malloc(strlen(str) + 1), *pbuf = buf;
  while (*pstr) {
    if (*pstr == '%') {
      if (pstr[1] && pstr[2]) {
        *pbuf++ = vv_utils_from_hex(pstr[1]) << 4 | vv_utils_from_hex(pstr[2]);
        pstr += 2;
      }
    } else if (*pstr == '+') {
      *pbuf++ = ' ';
    } else {
      *pbuf++ = *pstr;
    }
    pstr++;
  }
  *pbuf = '\0';
  return buf;
}

char *vv_utils_encode_html(const char *html) {
  char *buf = malloc(15 + (strlen(html) * 3) + 1);
  memcpy(buf, "data:text/html,", 15);
  vv_utils_url_encode_into(buf + 15, (char *)html);
  return buf;
}
