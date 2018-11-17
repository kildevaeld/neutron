#pragma once
/* Converts a hex character to its integer value */
char vv_utils_from_hex(char ch);
/* Converts an integer value to its hex character*/
char vv_utils_to_hex(char code);

/* Returns a url-encoded version of str */
/* IMPORTANT: be sure to free() the returned string after use */
char *vv_utils_url_encode(char *str);
void vv_utils_url_encode_into(char *dest, char *source);

/* Returns a url-decoded version of str */
/* IMPORTANT: be sure to free() the returned string after use */
char *vv_utils_url_decode(char *str);

char *vv_utils_encode_html(const char *html);
