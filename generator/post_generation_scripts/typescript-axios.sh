#!/bin/sh
sed -i 's/name: "RequiredError"/override name: "RequiredError"/g' $(find out/qovery-client-typescript-axios/base.ts -type f)