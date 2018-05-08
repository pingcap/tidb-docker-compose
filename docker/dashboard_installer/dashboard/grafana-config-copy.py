#!/usr/bin/env python

from __future__ import print_function, \
    unicode_literals

import urllib
import urllib2
import base64
import json
import sys
from pprint import pprint

try:
    input = raw_input
except:
    pass

############################################################
################## CONFIGURATION ###########################
############################################################

# use a viewer key
src = dict(
    dashboards={
                "pd"  : 'pd.json',
                "tidb": 'tidb.json',
                "tikv": 'tikv.json',
                "overview": 'overview.json'
                })

dests = [
]

if not dests:
    with open("./dests.json") as fp:
        dests = json.load(fp)


############################################################
################## CONFIGURATION ENDS ######################
############################################################

def export_dashboard(api_url, api_key, dashboard_name):
    req = urllib2.Request(api_url + 'api/dashboards/db/' + dashboard_name,
                          headers={'Authorization': "Bearer {}".format(api_key)})

    resp = urllib2.urlopen(req)
    data = json.load(resp)
    return data['dashboard']


def fill_dashboard_with_dest_config(dashboard, dest, type_='node'):
    dashboard['title'] = dest['titles'][type_]
    dashboard['id'] = None
#    pprint(dashboard)
    for row in dashboard['rows']:
        for panel in row['panels']:
            panel['datasource'] = dest['datasource']

    if 'templating' in dashboard:
        for templating in dashboard['templating']['list']:
            if templating['type'] == 'query':
                templating['current'] = {}
                templating['options'] = []
            templating['datasource'] = dest['datasource']

    if 'annotations' in dashboard:
        for annotation in dashboard['annotations']['list']:
            annotation['datasource'] = dest['datasource']
    return dashboard

def import_dashboard_via_user_pass(api_url, user, password, dashboard):
    payload = {'dashboard': dashboard,
               'overwrite': True}
    auth_string = base64.b64encode('%s:%s' % (user, password))
    headers = {'Authorization': "Basic {}".format(auth_string),
               'Content-Type': 'application/json'}
    req = urllib2.Request(api_url + 'api/dashboards/db',
                          headers=headers,
                          data=json.dumps(payload))
    try:
        resp = urllib2.urlopen(req)
        data = json.load(resp)
        return data
    except urllib2.HTTPError, error:
        data = json.load(error)
        return data


if __name__ == '__main__':
    url = sys.argv[1]
    user = sys.argv[2]
    password = sys.argv[3]
    print(url)
    for type_ in src['dashboards']:
        print("[load] from <{}>:{}".format(
          src['dashboards'][type_], type_))

        dashboard = json.load(open(src['dashboards'][type_]))

        for dest in dests:
            dashboard = fill_dashboard_with_dest_config(dashboard, dest, type_)
            print("[import] as <{}> to [{}]".format(
                dashboard['title'], dest['name']), end='\t............. ')
            ret = import_dashboard_via_user_pass(url, user, password, dashboard)
            print(ret)

            if ret['status'] != 'success':
                print('  > ERROR: ', ret)
                raise RuntimeError
