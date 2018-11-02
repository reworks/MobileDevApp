-- metadata table, used to tell android systems what permissions we are using. We also have to specify these permissions in the android manifest.

local metadata =
{
    plugin =
    {
        manifest =
        {
            usesPermissions =
            {
                "android.permission.SEND_SMS",
                "android.permission.RECORD_AUDIO",
                "android.permission.CAMERA"
            },
        },
    },
}
return metadata