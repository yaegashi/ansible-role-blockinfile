Ansible Role: blockinfile
=========================

This role contains no tasks, but provides blockinfile module
which might be useful when you want to apply multi-line snippets
in config files in /etc.

blockinfile Module
------------------

### Options

<table border=1 cellpadding=4>
<tr>
<th class="head">parameter</th>
<th class="head">required</th>
<th class="head">default</th>
<th class="head">choices</th>
<th class="head">comments</th>
</tr>
<tr>
<td>backup</td>
<td>no</td>
<td>no</td>
<td><ul><li>yes</li><li>no</li></ul></td>
<td>Create a backup file including the timestamp information so you can get the original file back if you somehow clobbered it incorrectly.</td>
</tr>
<tr>
<td>content</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>The text to insert inside the marker lines. If it's empty string, marker lines will also be removed.</td>
</tr>
<tr>
<td>create</td>
<td>no</td>
<td>no</td>
<td><ul><li>yes</li><li>no</li></ul></td>
<td>Create a new file if it doesn't exist.</td>
</tr>
<tr>
<td>dest</td>
<td>yes</td>
<td></td>
<td><ul></ul></td>
<td>The file to modify.</td>
</tr>
<tr>
<td>marker</td>
<td>no</td>
<td># {mark} ANSIBLE MANAGED BLOCK</td>
<td><ul></ul></td>
<td>The marker line template. "{mark}" will be replaced with "BEGIN" or "END".</td>
</tr>
<tr>
<td>others</td>
<td>no</td>
<td></td>
<td><ul></ul></td>
<td>All arguments accepted by the <span class='module'>file</span> module also work here.</td>
</tr>
<tr>
<td>validate</td>
<td>no</td>
<td>None</td>
<td><ul></ul></td>
<td>validation to run before copying into place</td>
</tr>
</table>

### Examples

Simple task with YAML block literal:

```yaml
- blockinfile: |
    dest=/etc/network/interfaces backup=yes
    content="iface eth0 inet static
        address 192.168.0.1
        netmask 255.255.255.0"
```

It will insert/update the following text block in /etc/network/interfaces:

```
# BEGIN ANSIBLE MANAGED BLOCK
iface eth0 inet static
    address 192.168.0.1
    netmask 255.255.255.0
# END ANSIBLE MANAGED BLOCK
```

Another task with alternative marker lines and variable substitution:

```yaml
- blockinfile: |
    dest=/var/www/html/index.html backup=yes
    marker="<!-- {mark} ANSIBLE MANAGED BLOCK -->"
    content="<h1>Welcome to {{ansible_hostname}}</h1>"
```

Requirements
------------

None.

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

Complete playbook
that makes SSH password authentication for specific user prohibited,
then restarts sshd if needed.

```yaml
---
- hosts: all
  remote_user: ansible-agent
  sudo: yes
  roles:
    - yaegashi.blockinfile
  tasks:
    - name: Prohibit SSH password authentication for $SUDO_USER
      blockinfile: |
        dest=/etc/ssh/sshd_config backup=yes
        content='Match User {{ansible_env.SUDO_USER}}\nPasswordAuthentication no'
      notify: Restart sshd
  handlers:
    - name: Restart sshd
      service: name=ssh state=restarted
```

License
-------

GPLv3+

Author Information
------------------

[YAEGASHI Takeshi](https://github.com/yaegashi)
