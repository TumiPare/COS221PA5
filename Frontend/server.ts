import 'zone.js/dist/zone-node';
import 'source-map-support/register';// for debuging compiled 

import { ngExpressEngine } from '@nguniversal/express-engine';
import * as express from 'express';
import { join } from 'path';
import { v4 as uuidv4 } from 'uuid';

import { AppServerModule } from './src/main.server';
import { APP_BASE_HREF } from '@angular/common';
import { existsSync } from 'fs';

declare global {
  namespace Express {
    interface Request {
      session: any;
    }
  }
}

// The Express app is exported so that it can be used by serverless Functions.
export function app(): express.Express {
  const session = require('express-session');
  const sql = require('./dist/faade/useMysql');
  const bodyParser = require('body-parser');

  const server = express();
  const distFolder = join(process.cwd(), 'dist/faade/browser');
  const indexHtml = existsSync(join(distFolder, 'index.original.html')) ? 'index.original.html' : 'index';

  server.engine('html', ngExpressEngine({
    bootstrap: AppServerModule,
  }));

  server.set('view engine', 'html');
  server.set('views', distFolder);

  // Example Express Rest API endpoints
  server.use(bodyParser.json());
  server.use(bodyParser.urlencoded({ extended: true }));
  // server.use(session({
  //   genid: () => {
  //     return uuidv4();
  //   },
  //   store: sql.MYSQLStore(),
  //   secret: 'proper proper',
  //   resave: false,
  //   saveUninitialized: true,
  //   cookie: { maxAge: 5256000000, SameSite: true } // 60 days
  // }));

  server.get('/API/getEvents', (req, res) => {
    sql.getEvents((events) => {
      res.json(events);
      res.end();
    });
  });

  server.get('/API/getEvent', (req, res) => {
    sql.getEvent(req.headers.eventid, (event) => {
      res.json(event);
      res.end();
    });
  });
  // Serve static files from /browser
  server.get('*.*', express.static(distFolder, {
    maxAge: '1y'
  }));

  // All regular routes use the Universal engine
  server.get('*', (req, res) => {
    res.render(indexHtml, { req, providers: [{ provide: APP_BASE_HREF, useValue: req.baseUrl }] });
  });

  return server;
}

function run(): void {
  const port = process.env.PORT || 4000;

  // Start up the Node server
  const server = app();
  server.listen(port, () => {
    console.log(`Node Express server listening on http://localhost:${port}`);
  });
}

// Webpack will replace 'require' with '__webpack_require__'
// '__non_webpack_require__' is a proxy to Node 'require'
// The below code is to ensure that the server is run only when not requiring the bundle.
declare const __non_webpack_require__: NodeRequire;
const mainModule = __non_webpack_require__.main;
const moduleFilename = mainModule && mainModule.filename || '';
if (moduleFilename === __filename || moduleFilename.includes('iisnode')) {
  run();
}

export * from './src/main.server';
