/*
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module bindbc.libuvc.libuvc;

import core.stdc.stdio : FILE;
import core.stdc.stdint;
import core.sys.posix.sys.time : timespec, timeval;

extern(C) @nogc nothrow @system:

struct libusb_context;
struct libusb_device_handle;

enum uvc_error
{
    UVC_SUCCESS = 0,
    UVC_ERROR_IO = -1,
    UVC_ERROR_INVALID_PARAM = -2,
    UVC_ERROR_ACCESS = -3,
    UVC_ERROR_NO_DEVICE = -4,
    UVC_ERROR_NOT_FOUND = -5,
    UVC_ERROR_BUSY = -6,
    UVC_ERROR_TIMEOUT = -7,
    UVC_ERROR_OVERFLOW = -8,
    UVC_ERROR_PIPE = -9,
    UVC_ERROR_INTERRUPTED = -10,
    UVC_ERROR_NO_MEM = -11,
    UVC_ERROR_NOT_SUPPORTED = -12,
    UVC_ERROR_INVALID_DEVICE = -50,
    UVC_ERROR_INVALID_MODE = -51,
    UVC_ERROR_CALLBACK_EXISTS = -52,
    UVC_ERROR_OTHER = -99
}
alias uvc_error_t = uvc_error;

enum uvc_frame_format
{
    UVC_FRAME_FORMAT_UNKNOWN = 0,
    UVC_FRAME_FORMAT_ANY = 0,
    UVC_FRAME_FORMAT_UNCOMPRESSED,
    UVC_FRAME_FORMAT_COMPRESSED,
    UVC_FRAME_FORMAT_YUYV,
    UVC_FRAME_FORMAT_UYVY,
    UVC_FRAME_FORMAT_RGB,
    UVC_FRAME_FORMAT_BGR,
    UVC_FRAME_FORMAT_MJPEG,
    UVC_FRAME_FORMAT_H264,
    UVC_FRAME_FORMAT_GRAY8,
    UVC_FRAME_FORMAT_GRAY16,
    UVC_FRAME_FORMAT_BY8,
    UVC_FRAME_FORMAT_BA81,
    UVC_FRAME_FORMAT_SGRBG8,
    UVC_FRAME_FORMAT_SGBRG8,
    UVC_FRAME_FORMAT_SRGGB8,
    UVC_FRAME_FORMAT_SBGGR8,
    UVC_FRAME_FORMAT_NV12,
    UVC_FRAME_FORMAT_P010,
    UVC_FRAME_FORMAT_COUNT,
}

enum uvc_color_format
{
    UVC_COLOR_FORMAT_UNKNOWN = uvc_frame_format.UVC_FRAME_FORMAT_UNKNOWN,
    UVC_COLOR_FORMAT_UNCOMPRESSED = uvc_frame_format.UVC_FRAME_FORMAT_UNCOMPRESSED,
    UVC_COLOR_FORMAT_COMPRESSED = uvc_frame_format.UVC_FRAME_FORMAT_COMPRESSED,
    UVC_COLOR_FORMAT_YUYV = uvc_frame_format.UVC_FRAME_FORMAT_YUYV,
    UVC_COLOR_FORMAT_UYVY = uvc_frame_format.UVC_FRAME_FORMAT_UYVY,
    UVC_COLOR_FORMAT_RGB = uvc_frame_format.UVC_FRAME_FORMAT_RGB,
    UVC_COLOR_FORMAT_BGR = uvc_frame_format.UVC_FRAME_FORMAT_BGR,
    UVC_COLOR_FORMAT_MJPEG = uvc_frame_format.UVC_FRAME_FORMAT_MJPEG,
    UVC_COLOR_FORMAT_GRAY8 = uvc_frame_format.UVC_FRAME_FORMAT_GRAY8,
    UVC_COLOR_FORMAT_GRAY16 = uvc_frame_format.UVC_FRAME_FORMAT_GRAY16,
    UVC_COLOR_FORMAT_NV12 = uvc_frame_format.UVC_FRAME_FORMAT_NV12,
}

enum uvc_vs_desc_subtype
{
    UVC_VS_UNDEFINED = 0x00,
    UVC_VS_INPUT_HEADER = 0x01,
    UVC_VS_OUTPUT_HEADER = 0x02,
    UVC_VS_STILL_IMAGE_FRAME = 0x03,
    UVC_VS_FORMAT_UNCOMPRESSED = 0x04,
    UVC_VS_FRAME_UNCOMPRESSED = 0x05,
    UVC_VS_FORMAT_MJPEG = 0x06,
    UVC_VS_FRAME_MJPEG = 0x07,
    UVC_VS_FORMAT_MPEG2TS = 0x0a,
    UVC_VS_FORMAT_DV = 0x0c,
    UVC_VS_COLORFORMAT = 0x0d,
    UVC_VS_FORMAT_FRAME_BASED = 0x10,
    UVC_VS_FRAME_FRAME_BASED = 0x11,
    UVC_VS_FORMAT_STREAM_BASED = 0x12
}

struct uvc_still_frame_res
{
    uvc_still_frame_res* prev;
    uvc_still_frame_res* next;
    uint8_t bResolutionIndex;
    uint16_t wWidth;
    uint16_t wHeight;
}
alias uvc_still_frame_res_t = uvc_still_frame_res;

struct uvc_still_frame_desc
{
  uvc_format_desc* parent;
  uvc_still_frame_desc* prev;
  uvc_still_frame_desc* next;
  uvc_vs_desc_subtype bDescriptorSubtype;
  uint8_t bEndPointAddress;
  uvc_still_frame_res_t* imageSizePatterns;
  uint8_t bNumCompressionPattern;
  uint8_t* bCompression;
}
alias uvc_still_frame_desc_t = uvc_still_frame_desc;

struct uvc_frame_desc
{
  uvc_format_desc* parent;
  uvc_frame_desc* prev;
  uvc_frame_desc* next;
  uvc_vs_desc_subtype bDescriptorSubtype;
  uint8_t bFrameIndex;
  uint8_t bmCapabilities;
  uint16_t wWidth;
  uint16_t wHeight;
  uint32_t dwMinBitRate;
  uint32_t dwMaxBitRate;
  uint32_t dwMaxVideoFrameBufferSize;
  uint32_t dwDefaultFrameInterval;
  uint32_t dwMinFrameInterval;
  uint32_t dwMaxFrameInterval;
  uint32_t dwFrameIntervalStep;
  uint8_t bFrameIntervalType;
  uint32_t dwBytesPerLine;
  uint32_t *intervals;
}
alias uvc_frame_desc_t = uvc_frame_desc;

struct uvc_streaming_interface;

struct uvc_format_desc
{
    uvc_streaming_interface* parent;
    uvc_format_desc* prev;
    uvc_format_desc* next;
    uvc_vs_desc_subtype bDescriptorSubtype;
    uint8_t bFormatIndex;
    uint8_t bNumFrameDescriptors;

    union
    {
        uint8_t[16] guidFormat;
        uint8_t[4] fourccFormat;
    }

    union
    {
        uint8_t bBitsPerPixel;
        uint8_t bmFlags;
    }

    uint8_t bDefaultFrameIndex;
    uint8_t bAspectRatioX;
    uint8_t bAspectRatioY;
    uint8_t bmInterlaceFlags;
    uint8_t bCopyProtect;
    uint8_t bVariableSize;
    uvc_frame_desc* frame_descs;
    uvc_still_frame_desc* still_frame_desc;
}
alias uvc_format_desc_t = uvc_format_desc;

enum uvc_req_code
{
    UVC_RC_UNDEFINED = 0x00,
    UVC_SET_CUR = 0x01,
    UVC_GET_CUR = 0x81,
    UVC_GET_MIN = 0x82,
    UVC_GET_MAX = 0x83,
    UVC_GET_RES = 0x84,
    UVC_GET_LEN = 0x85,
    UVC_GET_INFO = 0x86,
    UVC_GET_DEF = 0x87
}

enum uvc_device_power_mode
{
    UVC_VC_VIDEO_POWER_MODE_FULL = 0x000b,
    UVC_VC_VIDEO_POWER_MODE_DEVICE_DEPENDENT = 0x001b,
}

enum uvc_ct_ctrl_selector
{
    UVC_CT_CONTROL_UNDEFINED = 0x00,
    UVC_CT_SCANNING_MODE_CONTROL = 0x01,
    UVC_CT_AE_MODE_CONTROL = 0x02,
    UVC_CT_AE_PRIORITY_CONTROL = 0x03,
    UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL = 0x04,
    UVC_CT_EXPOSURE_TIME_RELATIVE_CONTROL = 0x05,
    UVC_CT_FOCUS_ABSOLUTE_CONTROL = 0x06,
    UVC_CT_FOCUS_RELATIVE_CONTROL = 0x07,
    UVC_CT_FOCUS_AUTO_CONTROL = 0x08,
    UVC_CT_IRIS_ABSOLUTE_CONTROL = 0x09,
    UVC_CT_IRIS_RELATIVE_CONTROL = 0x0a,
    UVC_CT_ZOOM_ABSOLUTE_CONTROL = 0x0b,
    UVC_CT_ZOOM_RELATIVE_CONTROL = 0x0c,
    UVC_CT_PANTILT_ABSOLUTE_CONTROL = 0x0d,
    UVC_CT_PANTILT_RELATIVE_CONTROL = 0x0e,
    UVC_CT_ROLL_ABSOLUTE_CONTROL = 0x0f,
    UVC_CT_ROLL_RELATIVE_CONTROL = 0x10,
    UVC_CT_PRIVACY_CONTROL = 0x11,
    UVC_CT_FOCUS_SIMPLE_CONTROL = 0x12,
    UVC_CT_DIGITAL_WINDOW_CONTROL = 0x13,
    UVC_CT_REGION_OF_INTEREST_CONTROL = 0x14
}

enum uvc_pu_ctrl_selector
{
    UVC_PU_CONTROL_UNDEFINED = 0x00,
    UVC_PU_BACKLIGHT_COMPENSATION_CONTROL = 0x01,
    UVC_PU_BRIGHTNESS_CONTROL = 0x02,
    UVC_PU_CONTRAST_CONTROL = 0x03,
    UVC_PU_GAIN_CONTROL = 0x04,
    UVC_PU_POWER_LINE_FREQUENCY_CONTROL = 0x05,
    UVC_PU_HUE_CONTROL = 0x06,
    UVC_PU_SATURATION_CONTROL = 0x07,
    UVC_PU_SHARPNESS_CONTROL = 0x08,
    UVC_PU_GAMMA_CONTROL = 0x09,
    UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL = 0x0a,
    UVC_PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL = 0x0b,
    UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL = 0x0c,
    UVC_PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL = 0x0d,
    UVC_PU_DIGITAL_MULTIPLIER_CONTROL = 0x0e,
    UVC_PU_DIGITAL_MULTIPLIER_LIMIT_CONTROL = 0x0f,
    UVC_PU_HUE_AUTO_CONTROL = 0x10,
    UVC_PU_ANALOG_VIDEO_STANDARD_CONTROL = 0x11,
    UVC_PU_ANALOG_LOCK_STATUS_CONTROL = 0x12,
    UVC_PU_CONTRAST_AUTO_CONTROL = 0x13
}

enum uvc_term_type
{
    UVC_TT_VENDOR_SPECIFIC = 0x0100,
    UVC_TT_STREAMING = 0x0101
}

enum uvc_it_type
{
    UVC_ITT_VENDOR_SPECIFIC = 0x0200,
    UVC_ITT_CAMERA = 0x0201,
    UVC_ITT_MEDIA_TRANSPORT_INPUT = 0x0202
}

enum uvc_ot_type
{
    UVC_OTT_VENDOR_SPECIFIC = 0x0300,
    UVC_OTT_DISPLAY = 0x0301,
    UVC_OTT_MEDIA_TRANSPORT_OUTPUT = 0x0302
}

enum uvc_et_type
{
    UVC_EXTERNAL_VENDOR_SPECIFIC = 0x0400,
    UVC_COMPOSITE_CONNECTOR = 0x0401,
    UVC_SVIDEO_CONNECTOR = 0x0402,
    UVC_COMPONENT_CONNECTOR = 0x0403
}

struct uvc_context;
alias uvc_context_t = uvc_context;
struct uvc_device;
alias uvc_device_t = uvc_device;
struct uvc_device_handle;
alias uvc_device_handle_t = uvc_device_handle;
struct uvc_stream_handle;
alias uvc_stream_handle_t = uvc_stream_handle;

struct uvc_input_terminal
{
  uvc_input_terminal* prev;
  uvc_input_terminal* next;
  uint8_t bTerminalID;
  uvc_it_type wTerminalType;
  uint16_t wObjectiveFocalLengthMin;
  uint16_t wObjectiveFocalLengthMax;
  uint16_t wOcularFocalLength;
  uint64_t bmControls;
}
alias uvc_input_terminal_t = uvc_input_terminal;

struct uvc_output_terminal
{
  uvc_output_terminal* prev;
  uvc_output_terminal* next;
}
alias uvc_output_terminal_t = uvc_output_terminal;

struct uvc_processing_unit
{
  uvc_processing_unit* prev;
  uvc_processing_unit* next;
  uint8_t bUnitID;
  uint8_t bSourceID;
  uint64_t bmControls;
}
alias uvc_processing_unit_t = uvc_processing_unit;

struct uvc_selector_unit
{
  uvc_selector_unit* prev;
  uvc_selector_unit* next;
  uint8_t bUnitID;
}
alias uvc_selector_unit_t = uvc_selector_unit;

struct uvc_extension_unit
{
  uvc_extension_unit* prev;
  uvc_extension_unit* next;
  uint8_t bUnitID;
  uint8_t[16] guidExtensionCode;
  uint64_t bmControls;
}
alias uvc_extension_unit_t = uvc_extension_unit;

enum uvc_status_class
{
  UVC_STATUS_CLASS_CONTROL = 0x10,
  UVC_STATUS_CLASS_CONTROL_CAMERA = 0x11,
  UVC_STATUS_CLASS_CONTROL_PROCESSING = 0x12,
}

enum uvc_status_attribute
{
  UVC_STATUS_ATTRIBUTE_VALUE_CHANGE = 0x00,
  UVC_STATUS_ATTRIBUTE_INFO_CHANGE = 0x01,
  UVC_STATUS_ATTRIBUTE_FAILURE_CHANGE = 0x02,
  UVC_STATUS_ATTRIBUTE_UNKNOWN = 0xff
}

alias uvc_status_callback_t = void function(
    uvc_status_class status_class,
    int event,
    int selector,
    uvc_status_attribute status_attribute,
    void* data,
    size_t data_len,
    void* user_ptr);
alias uvc_button_callback_t = void function(
    int button,
    int state,
    void* user_ptr);

struct uvc_device_descriptor
{
  uint16_t idVendor;
  uint16_t idProduct;
  uint16_t bcdUVC;
  const(char)* serialNumber;
  const(char)* manufacturer;
  const(char)* product;
}
alias uvc_device_descriptor_t = uvc_device_descriptor;

struct uvc_frame
{
  void* data;
  size_t data_bytes;
  uint32_t width;
  uint32_t height;
  uvc_frame_format frame_format;
  size_t step;
  uint32_t sequence;
  timeval capture_time;
  timespec capture_time_finished;
  uvc_device_handle_t *source;
  uint8_t library_owns_data;
  void* metadata;
  size_t metadata_bytes;
}
alias uvc_frame_t = uvc_frame;

alias uvc_frame_callback_t = void function(uvc_frame*, void*);

struct uvc_stream_ctrl_
{
  uint16_t bmHint;
  uint8_t bFormatIndex;
  uint8_t bFrameIndex;
  uint32_t dwFrameInterval;
  uint16_t wKeyFrameRate;
  uint16_t wPFrameRate;
  uint16_t wCompQuality;
  uint16_t wCompWindowSize;
  uint16_t wDelay;
  uint32_t dwMaxVideoFrameSize;
  uint32_t dwMaxPayloadTransferSize;
  uint32_t dwClockFrequency;
  uint8_t bmFramingInfo;
  uint8_t bPreferredVersion;
  uint8_t bMinVersion;
  uint8_t bMaxVersion;
  uint8_t bInterfaceNumber;
}
alias uvc_stream_ctrl_t = uvc_stream_ctrl_;

struct uvc_still_ctrl
{
  uint8_t bFormatIndex;
  uint8_t bFrameIndex;
  uint8_t bCompressionIndex;
  uint32_t dwMaxVideoFrameSize;
  uint32_t dwMaxPayloadTransferSize;
  uint8_t bInterfaceNumber;
}
alias uvc_still_ctrl_t = uvc_still_ctrl;

uvc_error_t uvc_init(uvc_context_t** ctx, libusb_context* usb_ctx);
void uvc_exit(uvc_context_t* ctx);
uvc_error_t uvc_get_device_list(uvc_context_t* ctx, uvc_device_t*** list);
void uvc_free_device_list(uvc_device_t** list, uint8_t unref_devices);
uvc_error_t uvc_get_device_descriptor(uvc_device_t* dev, uvc_device_descriptor_t** desc);
void uvc_free_device_descriptor(uvc_device_descriptor_t* desc);
uint8_t uvc_get_bus_number(uvc_device_t* dev);
uint8_t uvc_get_device_address(uvc_device_t* dev);
uvc_error_t uvc_find_device(uvc_context_t* ctx, uvc_device_t** dev, int vid, int pid, const(char)* sn);
uvc_error_t uvc_find_devices(uvc_context_t *ctx, uvc_device_t ***devs, int vid, int pid, const(char) *sn);
uvc_error_t uvc_wrap(int sys_dev, uvc_context_t* context, uvc_device_handle_t** devh);
uvc_error_t uvc_open(uvc_device_t* dev, uvc_device_handle_t** devh);
void uvc_close(uvc_device_handle_t* devh);
uvc_device_t *uvc_get_device(uvc_device_handle_t* devh);
libusb_device_handle* uvc_get_libusb_handle(uvc_device_handle_t* devh);
void uvc_ref_device(uvc_device_t* dev);
void uvc_unref_device(uvc_device_t* dev);
void uvc_set_status_callback(uvc_device_handle_t* devh, uvc_status_callback_t cb, void* user_ptr);
void uvc_set_button_callback(uvc_device_handle_t* devh, uvc_button_callback_t cb, void* user_ptr);
const (uvc_input_terminal_t)* uvc_get_camera_terminal(uvc_device_handle_t* devh);
const (uvc_input_terminal_t)* uvc_get_input_terminals(uvc_device_handle_t* devh);
const (uvc_output_terminal_t)* uvc_get_output_terminals(uvc_device_handle_t* devh);
const (uvc_selector_unit_t)* uvc_get_selector_units(uvc_device_handle_t* devh);
const (uvc_processing_unit_t)* uvc_get_processing_units(uvc_device_handle_t* devh);
const (uvc_extension_unit_t)* uvc_get_extension_units(uvc_device_handle_t* devh);
uvc_error_t uvc_get_stream_ctrl_format_size(
  uvc_device_handle_t* devh, uvc_stream_ctrl_t* ctrl, uvc_frame_format format, int width, int height, int fps);
uvc_error_t uvc_get_still_ctrl_format_size(uvc_device_handle_t* devh, uvc_stream_ctrl_t* ctrl, uvc_still_ctrl_t* still_ctrl, int width, int height);
uvc_error_t uvc_trigger_still(uvc_device_handle_t* devh, uvc_still_ctrl_t* still_ctrl);
const(uvc_format_desc_t)* uvc_get_format_descs(uvc_device_handle_t*);
uvc_error_t uvc_probe_stream_ctrl(uvc_device_handle_t* devh, uvc_stream_ctrl_t* ctrl);
uvc_error_t uvc_probe_still_ctrl(uvc_device_handle_t* devh, uvc_still_ctrl_t* still_ctrl);
uvc_error_t uvc_start_streaming(uvc_device_handle_t* devh, uvc_stream_ctrl_t* ctrl, uvc_frame_callback_t* cb, void* user_ptr, uint8_t flags);
uvc_error_t uvc_start_iso_streaming(uvc_device_handle_t* devh, uvc_stream_ctrl_t* ctrl, uvc_frame_callback_t* cb, void* user_ptr);
void uvc_stop_streaming(uvc_device_handle_t* devh);
uvc_error_t uvc_stream_open_ctrl(uvc_device_handle_t* devh, uvc_stream_handle_t* *strmh, uvc_stream_ctrl_t* ctrl);
uvc_error_t uvc_stream_ctrl(uvc_stream_handle_t* strmh, uvc_stream_ctrl_t* ctrl);
uvc_error_t uvc_stream_start(uvc_stream_handle_t* strmh, uvc_frame_callback_t* cb, void* user_ptr, uint8_t flags);
uvc_error_t uvc_stream_start_iso(uvc_stream_handle_t* strmh, uvc_frame_callback_t* cb, void* user_ptr);
uvc_error_t uvc_stream_get_frame(uvc_stream_handle_t* strmh, uvc_frame_t** frame, int32_t timeout_us);
uvc_error_t uvc_stream_stop(uvc_stream_handle_t* strmh);
void uvc_stream_close(uvc_stream_handle_t* strmh);
int uvc_get_ctrl_len(uvc_device_handle_t* devh, uint8_t unit, uint8_t ctrl);
int uvc_get_ctrl(uvc_device_handle_t* devh, uint8_t unit, uint8_t ctrl, void* data, int len, uvc_req_code req_code);
int uvc_set_ctrl(uvc_device_handle_t* devh, uint8_t unit, uint8_t ctrl, void* data, int len);
uvc_error_t uvc_get_power_mode(uvc_device_handle_t* devh, uvc_device_power_mode* mode, uvc_req_code req_code);
uvc_error_t uvc_set_power_mode(uvc_device_handle_t* devh, uvc_device_power_mode mode);
uvc_error_t uvc_get_scanning_mode(uvc_device_handle_t* devh, uint8_t* mode, uvc_req_code req_code);
uvc_error_t uvc_set_scanning_mode(uvc_device_handle_t* devh, uint8_t mode);
uvc_error_t uvc_get_ae_mode(uvc_device_handle_t* devh, uint8_t* mode, uvc_req_code req_code);
uvc_error_t uvc_set_ae_mode(uvc_device_handle_t* devh, uint8_t mode);
uvc_error_t uvc_get_ae_priority(uvc_device_handle_t* devh, uint8_t* priority, uvc_req_code req_code);
uvc_error_t uvc_set_ae_priority(uvc_device_handle_t* devh, uint8_t priority);
uvc_error_t uvc_get_exposure_abs(uvc_device_handle_t* devh, uint32_t* time, uvc_req_code req_code);
uvc_error_t uvc_set_exposure_abs(uvc_device_handle_t* devh, uint32_t time);
uvc_error_t uvc_get_exposure_rel(uvc_device_handle_t* devh, int8_t* step, uvc_req_code req_code);
uvc_error_t uvc_set_exposure_rel(uvc_device_handle_t* devh, int8_t step);
uvc_error_t uvc_get_focus_abs(uvc_device_handle_t* devh, uint16_t* focus, uvc_req_code req_code);
uvc_error_t uvc_set_focus_abs(uvc_device_handle_t* devh, uint16_t focus);
uvc_error_t uvc_get_focus_rel(uvc_device_handle_t* devh, int8_t* focus_rel, uint8_t* speed, uvc_req_code req_code);
uvc_error_t uvc_set_focus_rel(uvc_device_handle_t* devh, int8_t focus_rel, uint8_t speed);
uvc_error_t uvc_get_focus_simple_range(uvc_device_handle_t* devh, uint8_t* focus, uvc_req_code req_code);
uvc_error_t uvc_set_focus_simple_range(uvc_device_handle_t* devh, uint8_t focus);
uvc_error_t uvc_get_focus_auto(uvc_device_handle_t* devh, uint8_t* state, uvc_req_code req_code);
uvc_error_t uvc_set_focus_auto(uvc_device_handle_t* devh, uint8_t state);
uvc_error_t uvc_get_iris_abs(uvc_device_handle_t* devh, uint16_t* iris, uvc_req_code req_code);
uvc_error_t uvc_set_iris_abs(uvc_device_handle_t* devh, uint16_t iris);
uvc_error_t uvc_get_iris_rel(uvc_device_handle_t* devh, uint8_t* iris_rel, uvc_req_code req_code);
uvc_error_t uvc_set_iris_rel(uvc_device_handle_t* devh, uint8_t iris_rel);
uvc_error_t uvc_get_zoom_abs(uvc_device_handle_t* devh, uint16_t* focal_length, uvc_req_code req_code);
uvc_error_t uvc_set_zoom_abs(uvc_device_handle_t* devh, uint16_t focal_length);
uvc_error_t uvc_get_zoom_rel(uvc_device_handle_t* devh, int8_t* zoom_rel, uint8_t* digital_zoom, uint8_t* speed, uvc_req_code req_code);
uvc_error_t uvc_set_zoom_rel(uvc_device_handle_t* devh, int8_t zoom_rel, uint8_t digital_zoom, uint8_t speed);
uvc_error_t uvc_get_pantilt_abs(uvc_device_handle_t* devh, int32_t* pan, int32_t* tilt, uvc_req_code req_code);
uvc_error_t uvc_set_pantilt_abs(uvc_device_handle_t* devh, int32_t pan, int32_t tilt);
uvc_error_t uvc_get_pantilt_rel(uvc_device_handle_t* devh, int8_t* pan_rel, uint8_t* pan_speed, int8_t* tilt_rel, uint8_t* tilt_speed, uvc_req_code req_code);
uvc_error_t uvc_set_pantilt_rel(uvc_device_handle_t* devh, int8_t pan_rel, uint8_t pan_speed, int8_t tilt_rel, uint8_t tilt_speed);
uvc_error_t uvc_get_roll_abs(uvc_device_handle_t* devh, int16_t* roll, uvc_req_code req_code);
uvc_error_t uvc_set_roll_abs(uvc_device_handle_t* devh, int16_t roll);
uvc_error_t uvc_get_roll_rel(uvc_device_handle_t* devh, int8_t* roll_rel, uint8_t* speed, uvc_req_code req_code);
uvc_error_t uvc_set_roll_rel(uvc_device_handle_t* devh, int8_t roll_rel, uint8_t speed);
uvc_error_t uvc_get_privacy(uvc_device_handle_t* devh, uint8_t* privacy, uvc_req_code req_code);
uvc_error_t uvc_set_privacy(uvc_device_handle_t* devh, uint8_t privacy);
uvc_error_t uvc_get_digital_window(uvc_device_handle_t* devh, uint16_t* window_top, uint16_t* window_left, uint16_t* window_bottom, uint16_t* window_right, uint16_t* num_steps, uint16_t* num_steps_units, uvc_req_code req_code);
uvc_error_t uvc_set_digital_window(uvc_device_handle_t* devh, uint16_t window_top, uint16_t window_left, uint16_t window_bottom, uint16_t window_right, uint16_t num_steps, uint16_t num_steps_units);
uvc_error_t uvc_get_digital_roi(uvc_device_handle_t* devh, uint16_t* roi_top, uint16_t* roi_left, uint16_t* roi_bottom, uint16_t* roi_right, uint16_t* auto_controls, uvc_req_code req_code);
uvc_error_t uvc_set_digital_roi(uvc_device_handle_t* devh, uint16_t roi_top, uint16_t roi_left, uint16_t roi_bottom, uint16_t roi_right, uint16_t auto_controls);
uvc_error_t uvc_get_backlight_compensation(uvc_device_handle_t* devh, uint16_t* backlight_compensation, uvc_req_code req_code);
uvc_error_t uvc_set_backlight_compensation(uvc_device_handle_t* devh, uint16_t backlight_compensation);
uvc_error_t uvc_get_brightness(uvc_device_handle_t* devh, int16_t* brightness, uvc_req_code req_code);
uvc_error_t uvc_set_brightness(uvc_device_handle_t* devh, int16_t brightness);
uvc_error_t uvc_get_contrast(uvc_device_handle_t* devh, uint16_t* contrast, uvc_req_code req_code);
uvc_error_t uvc_set_contrast(uvc_device_handle_t* devh, uint16_t contrast);
uvc_error_t uvc_get_contrast_auto(uvc_device_handle_t* devh, uint8_t* contrast_auto, uvc_req_code req_code);
uvc_error_t uvc_set_contrast_auto(uvc_device_handle_t* devh, uint8_t contrast_auto);
uvc_error_t uvc_get_gain(uvc_device_handle_t* devh, uint16_t* gain, uvc_req_code req_code);
uvc_error_t uvc_set_gain(uvc_device_handle_t* devh, uint16_t gain);
uvc_error_t uvc_get_power_line_frequency(uvc_device_handle_t* devh, uint8_t* power_line_frequency, uvc_req_code req_code);
uvc_error_t uvc_set_power_line_frequency(uvc_device_handle_t* devh, uint8_t power_line_frequency);
uvc_error_t uvc_get_hue(uvc_device_handle_t* devh, int16_t* hue, uvc_req_code req_code);
uvc_error_t uvc_set_hue(uvc_device_handle_t* devh, int16_t hue);
uvc_error_t uvc_get_hue_auto(uvc_device_handle_t* devh, uint8_t* hue_auto, uvc_req_code req_code);
uvc_error_t uvc_set_hue_auto(uvc_device_handle_t* devh, uint8_t hue_auto);
uvc_error_t uvc_get_saturation(uvc_device_handle_t* devh, uint16_t* saturation, uvc_req_code req_code);
uvc_error_t uvc_set_saturation(uvc_device_handle_t* devh, uint16_t saturation);
uvc_error_t uvc_get_sharpness(uvc_device_handle_t* devh, uint16_t* sharpness, uvc_req_code req_code);
uvc_error_t uvc_set_sharpness(uvc_device_handle_t* devh, uint16_t sharpness);
uvc_error_t uvc_get_gamma(uvc_device_handle_t* devh, uint16_t* gamma, uvc_req_code req_code);
uvc_error_t uvc_set_gamma(uvc_device_handle_t* devh, uint16_t gamma);
uvc_error_t uvc_get_white_balance_temperature(uvc_device_handle_t* devh, uint16_t* temperature, uvc_req_code req_code);
uvc_error_t uvc_set_white_balance_temperature(uvc_device_handle_t* devh, uint16_t temperature);
uvc_error_t uvc_get_white_balance_temperature_auto(uvc_device_handle_t* devh, uint8_t* temperature_auto, uvc_req_code req_code);
uvc_error_t uvc_set_white_balance_temperature_auto(uvc_device_handle_t* devh, uint8_t temperature_auto);
uvc_error_t uvc_get_white_balance_component(uvc_device_handle_t* devh, uint16_t* blue, uint16_t* red, uvc_req_code req_code);
uvc_error_t uvc_set_white_balance_component(uvc_device_handle_t* devh, uint16_t blue, uint16_t red);
uvc_error_t uvc_get_white_balance_component_auto(uvc_device_handle_t* devh, uint8_t* white_balance_component_auto, uvc_req_code req_code);
uvc_error_t uvc_set_white_balance_component_auto(uvc_device_handle_t* devh, uint8_t white_balance_component_auto);
uvc_error_t uvc_get_digital_multiplier(uvc_device_handle_t* devh, uint16_t* multiplier_step, uvc_req_code req_code);
uvc_error_t uvc_set_digital_multiplier(uvc_device_handle_t* devh, uint16_t multiplier_step);
uvc_error_t uvc_get_digital_multiplier_limit(uvc_device_handle_t* devh, uint16_t* multiplier_step, uvc_req_code req_code);
uvc_error_t uvc_set_digital_multiplier_limit(uvc_device_handle_t* devh, uint16_t multiplier_step);
uvc_error_t uvc_get_analog_video_standard(uvc_device_handle_t* devh, uint8_t* video_standard, uvc_req_code req_code);
uvc_error_t uvc_set_analog_video_standard(uvc_device_handle_t* devh, uint8_t video_standard);
uvc_error_t uvc_get_analog_video_lock_status(uvc_device_handle_t* devh, uint8_t* status, uvc_req_code req_code);
uvc_error_t uvc_set_analog_video_lock_status(uvc_device_handle_t* devh, uint8_t status);
uvc_error_t uvc_get_input_select(uvc_device_handle_t* devh, uint8_t* selector, uvc_req_code req_code);
uvc_error_t uvc_set_input_select(uvc_device_handle_t* devh, uint8_t selector);
void uvc_perror(uvc_error_t err, const(char)* msg);
const(char)* uvc_strerror(uvc_error_t err);
void uvc_print_diag(uvc_device_handle_t* devh, FILE* stream);
void uvc_print_stream_ctrl(uvc_stream_ctrl_t* ctrl, FILE* stream);
uvc_frame_t* uvc_allocate_frame(size_t data_bytes);
void uvc_free_frame(uvc_frame_t* frame);
uvc_error_t uvc_duplicate_frame(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_yuyv2rgb(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_uyvy2rgb(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_any2rgb(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_yuyv2bgr(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_uyvy2bgr(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_any2bgr(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_yuyv2y(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_yuyv2uv(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_mjpeg2rgb(uvc_frame_t* in_, uvc_frame_t* out_);
uvc_error_t uvc_mjpeg2gray(uvc_frame_t* in_, uvc_frame_t* out_);
