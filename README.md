# Theses-Checker

### Autor: Michaela Macková ([michaela.mackovaa@gmail.com](mailto:michaela.mackovaa@gmail.com))
---

The developed applications implement a tool that checks for typographical errors that often occur in theses and analyzes it's content for quick evaluation on it's length. Two applications were created: one web-based and the other command-line executable. Both applications were developed in Python and use the [PyMuPDF](https://pymupdf.readthedocs.io/en/latest/) library to process PDF documents.

***This program is a part of a bachelor's thesis and later extended as Project Practice.***



--- 

### Web tool

The developed web application is freely available at <https://theseschecker.eu.pythonanywhere.com/>.

The input of this application is a PDF file containing the technical report that will be checked and analyzed. The output is the same file with graphical indications of any identified mistakes and information about the text and pictures of the document. The edited PDF is displayed directly on the web page, with errors marked using PDF annotations.

### Command-line executable

The input to this application is one or more PDF files, each containing a technical report that will be checked. Using the available arguments, you can set which checks are performed and whether embedded PDF files (located inside the PDF documents) are treated as images during the checks. The output consists of the provided PDF files, each accompanied by a graphical indication of any identified mistakes, with errors marked using PDF annotations, and text files containing information about text and pictures for each input PDF file.



## Contents
* [Bachelor's thesis](#bachelors-thesis)
- [Development](#development)
    * [1. Installation of dependencies](#1-installation-of-dependencies)
        + [Web tool](#web-tool-1)
        + [Command-line executable](#command-line-executable-1)
    * [2. Before first use](#2-before-first-use)
        + [Web tool](#web-tool-2)
        + [Command-line executable](#command-line-executable-2)
    * [3. Usage](#3-usage)
        + [Web tool](#web-tool-3)
        + [Command-line executable](#command-line-executable-3)
    * [4. For web server with small storage space](#4-for-web-server-with-small-storage-space)
        + [4.1. Bash/Powershell script for periodic deletion](#41-bash-powershell-script-for-periodic-deletion)
            - [4.1.1. Python script for periodic tasks](#411-python-script-for-periodic-tasks)
        + [4.2. Delete when loaded on the user's side](#42-delete-when-loaded-on-the-user-s-side)
- [Known Issues](#known-issues)



---
## Bachelor's thesis
If you want to learn more and know Czech you can read my thesis at
[https://www.vut.cz/studenti/zav-prace/detail/144733](https://www.vut.cz/studenti/zav-prace/detail/144733).

> **Abstract:** </br>
> The main goal of this work is to create an application that checks technical reports and
marks all the found errors with PDF annotations. The technical documentation of this thesis
breaks down the structure of a PDF file, commonly found mistakes in graduate theses, web
development using the Django framework and discusses existing libraries for editing PDF
documents. The resulting application is implemented in Python and is accessible as a web
tool with the help of the Django framework. The developed solution recognizes six mostly
typographical errors frequently found in graduate theses. The mistakes found are visually
marked and the edited PDF file is then displayed directly on the web page. The resulting
tool is freely available and helps students and supervisors to correct the technical reports
the students create.


---
---
# Development

## 1. Installation of dependencies

Before running the program, you must install all the packages on which the application depends. For easier installation, files have been created containing the packages and their versions that can be used with the `pip install` command. These files are stored in the root folder. Both versions of Theses Checker (the web tool and the command line program) were developed in the **Python programming language version 3.10**.
Other versions have not been tested.

### Web tool

To install dependencies for the *web tool*, use the following command:

```
> pip install -r requirements_web.txt
```

### Command-line executable

To install dependencies for the *command-line executable*, use the following command:

```
> pip install -r requirements.txt
```



---
## 2. Before first use

After installing the dependencies, you’ll need to make a few adjustments before using either application for the first time.

### Web tool

+ For the web application to work properly, the `theses_checker.py`, `chapter_info.py`, `chapter_info_advanced.py` and `standard_pages.py` files must be located in the `src\web\theses_checker\bl\` folder (their original location).
+ The next step is creating a `.env` file in `src\web\` folder. This file is described later in this section.
+ The tool creates and stores new PDF and JSON files, for our developed strategies on how to delete these files see section [4. For web server with small storage space](#4-for-web-server-with-small-storage-space).


#### Specifications for `.env` file

This file should contain:
+ **[required] `SECRET_KEY`** - The **secret key** that should be set before this application is published. The file must contain a line starting with `SECRET_KEY=` followed by the newly generated secret key. The example below contains the base value of the secret key, but this value must be manually changed to maintain security. This secret key can be generated, for example, at [Djecrety](https://djecrety.ir/).
+ **[required] `DEBUG`** - The **debug configuration** that should be set to `True` in production. The file must contain a line starting with `DEBUG=` followed by `True` or `False`. This variable is used to specify whether the application will run in development mode or production mode. (Static files such as `style.css` and `script.js` may not function correctly in production mode on the local server.)
+ **[required] `OPERATING_SYSTEM`** - The **operating system name** on which this tool is running. The file must contain a line starting with `OPERATING_SYSTEM=` followed by either `Windows` or `Linux`. Other types are not supported.
+ **`MAX_STORAGE_SPACE`** - The **maximum storage space available** (in bytes) for the whole repository. The file must contain a line starting with `MAX_STORAGE_SPACE=` followed by a number. If it is not stated in `.env` file the maximum storage space is determined by the system. (WARNING: only for Linux, for Windows ignored)
+ **`ALLOWED_HOSTS`** - List of **allowed host/domain names** that this Django site can serve. This list can include fully qualified names (e.g. *`www.example.com`*) and subdomains (e.g. *`.example.com`*, that matches all subdomains of ***example.com***). The `.env` file must contain a line starting with `ALLOWED_HOSTS=` followed by a list of domains. If `ALLOWED_HOSTS` is not specified default `.localhost, 127.0.0.1, [::1]` will be applied.
* **`CSRF_TRUSTED_ORIGINS`** - A list of **trusted origins** for unsafe requests. If cross-origin unsafe requests are needed. This list can include for example *`https://secure.example.com`*, *`http://insecure.example.com`* or *`https://*.example.com`* (to allow access from all subdomains of ***example.com***). To use this setting the `.env` file must contain a line starting with `CSRF_TRUSTED_ORIGINS=` followed by list of trusted origins.
+ **`FORCE_SCRIPT_NAME`** - This will be used as the value of the *SCRIPT_NAME* environment variable in any HTTP request. If needed the `.env` file must contain a line `FORCE_SCRIPT_NAME=` followed by script name.
+ **`CSRF_COOKIE_PATH`** - The path set on the **CSRF cookie**. To use this setting the `.env` file must contain a line starting with `CSRF_COOKIE_PATH=` followed by CSRF cookie path. Default path is `/`.
+ **`RELATIVE_STATIC_ROOT`** - Path (relative to `BASE_DIR`) to the directory where `collectstatic` will **collect static files** for deployment. For example *`path/to/collectstatic`*. To use this the `.env` file must contain a line starting with `RELATIVE_STATIC_ROOT=` followed by a path.
+ **`STATIC_URL`** - URL to use when **referring to static files** located in `RELATIVE_STATIC_ROOT`. For example *`static/`* or *`http://static.example.com/`* (value must end in a slash). To use this the `.env` file must contain a line starting with `STATIC_URL=` followed by URL.

**valid `.env` file examples:**
```
SECRET_KEY=django-insecure-8%7#%6m22)=2**4c50n1h-&_!z_&3os6r+0g3_0eofna9mlkx*
DEBUG=True
ALLOWED_HOSTS=127.0.0.1, .localhost, my.example.site.com, .subdomain.example.org
CSRF_TRUSTED_ORIGINS=https://example.com, http://another.example.com
STATIC_URL=static/
OPERATING_SYSTEM=Windows
```
```
SECRET_KEY=django-insecure-8%7#%6m22)=2**4c50n1h-&_!z_&3os6r+0g3_0eofna9mlkx*
DEBUG=False
OPERATING_SYSTEM=Linux
FORCE_SCRIPT_NAME=/my-script-name
ALLOWED_HOSTS=my.example.site.com, .localhost, 127.0.0.1, [::1]
STATIC_URL=/url/example/static/
RELATIVE_STATIC_ROOT=collectedstaticfiles/path
CSRF_COOKIE_PATH=/cookie-path
```
```
SECRET_KEY=django-insecure-8%7#%6m22)=2**4c50n1h-&_!z_&3os6r+0g3_0eofna9mlkx*
DEBUG=True
OPERATING_SYSTEM=Linux
FORCE_SCRIPT_NAME=/
MAX_STORAGE_SPACE=536870912000
```
```
SECRET_KEY=django-insecure-8%7#%6m22)=2**4c50n1h-&_!z_&3os6r+0g3_0eofna9mlkx*
DEBUG=False
OPERATING_SYSTEM=Windows
```
*Note: It is important not to assign values in the quotation in `.env` file*

### Command-line executable

+ In order for the command line program to work properly, the `theses_checker.py`, `chapter_info.py`, `chapter_info_advanced.py` and `standard_pages.py` files must be located in the `%CMD%\theses_checker_package\` folder.
+ These files are originally located in the `src\web\theses_checker\bl\` folder.
+ For easier use (while following the originally set hierarchy) `copy_theses_checker_package.ps1` or `copy_theses_checker_package.sh` scripts can be used to copy these files. These scripts are located inside the `src\cmd\` folder.
+ Next ensure that `check.py` file is inside `%CMD%\` folder.
+ `%CMD%` path originally represents `src\cmd\`.

**Expected file hierarchy:**
```
%CMD%
├── theses_checker_package
│   ├── __init__.py
│   ├── chapter_info_advanced.py
│   ├── chapter_info.py
│   ├── standard_pages.py
│   └── theses_checker.py
├── __init__.py
├── check.py
├── copy_theses_checker_package.ps1 [optional]
└── copy_theses_checker_package.sh [optional]
```



---
## 3. Usage

### Web tool

To start the server locally for the web tool, use this command (used primarily for debugging purposes):
```
> python manage.py runserver
```

### Command-line executable

To execute this program, use the following command:

```
> python check.py [ARG]… in_file [in_file]…
```

**Command description:** Makes a new pdf file called '*_annotated.pdf' in the folder, where this program is saved. If no check flag is given, everything will be checked.

Available arguments are:

+ `-h` or `--help`
+ `--embedded_PDF` - if used, embedded PDF files will be treated as part of the PDF; otherwise, they will be considered as images
+ `-o` or `--overflow` - performs overflow check
+ `-i` or `--image_width` - performs image width check
+ `-H` or `--Hyphen` - performs hyphen check
+ `-t` or `--TOC` - performs table of content section check
+ `-s` or `--space_bracket` - performs space before left bracket check
+ `-e` or `--empty_chapter` - performs text between titles check
+ `-b` or `--bad_reference` - performs bad reference check (finding '??' in text - usually found in PDFs exported from LaTeX)

The application can be used as follows:

```
> python check.py -h
```

```
> python check.py file.pdf
```

```
> python check.py file1.pdf file2.pdf file3.pdf
```

```
> python check.py -o -t file.pdf file2.pdf
```

```
> python check.py file.pdf -H -s -b
```



---
## 4. For web server with small storage space

In case server has small storage space there were developed two strategies on how to delete annotated PDF files:


### 4.1. Bash/Powershell script for periodic deletion


***Note: This script does not run by itself. For it to work you need to schedule a job (for example as cron job) or use `periodicTasks.py` script.***

This script is located in `src\web\` folder and is named `periodicDeleteFiles.sh` for Linux systems or `periodicDeleteFiles.ps1` for Windows systems. When this script is run, it deletes all PDF files located in in `.\files\` or `.\static\` folder and all JSON files located in `.\files\json` folder that are older than specified period (originally set to 12h). To change this period, simply change the value (in seconds) in `Period` variable.

This script can by run on *Linux* by this command:
```
$ bash periodicDeleteFiles.sh
```

This script can by run on *Windows* by this command:
```
> powershell '& periodicDeleteFiles.sh'
```


#### 4.1.1. Python script for periodic tasks

For easier use of scripts for periodic deletion a scheduling script has been created - named `periodicTasks.py`. This script is located in `src\web\` folder and for its usage a new dependency is neeed. These dependencies are listed in `requirements_scheduler.txt`. To install these dependencies you can use command:
```
> pip install -r requirements_scheduler.txt
```

This script runs indefinitelly and periodically executes file-deletion task. This period is initally set to: every day at 8:00 and 20:00. You can change the execute times by changing the `DELETE_FILES_TIMES` variable.

Script can be run by this command:
```
> python periodicTasks.py
```


### 4.2. Delete when loaded on the user's side

***Note: By using this method, web cannot be used on mobile devices - PDF is deleted before user can download resource from server.***

This option relies on user's web browser to store PDF in temporary storage. PDF file is sent as (a part of) a HTTP response and than deleted from server.

There are a few steps to set up if you want to use this option:
1. in `src\web\theses_checker\views.py` uncomment method `view_annotated` (lines 67-81)
2. in `src\web\theses_checker\urls.py` uncomment/add new path to `urlpatterns` list:
    ```
    path('view/<str:pdf_name>', views.view_annotated, name='view_annotated')
    ```
3. in `src\web\templates\theses_checker\annotated.html` set `<iframe>` source (src) to following (as seen in comment in file). By using this source, there is no need to load static in template anymore
    ```
    "{% url 'view_annotated' pdf_name=pdf_name %}"
    ```  



---
---
# Known Issues

+ overflow check doesn't work for two-sided papers (padding on odd pages is different than padding on even pages)
+ some files (when user leaves mid request?) stay in `static` folder
+ when error is thrown during file processing, files stay in `files` folder
+ in some cases chapter titles are not recognized
+ chapter detection and adding content information for chapter depends on condition, that chapter title is always on a new page 
