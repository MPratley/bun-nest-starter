import { Test, TestingModule } from '@nestjs/testing';
import { type INestApplication } from '@nestjs/common';
import {
  makeFetch,
  type IExpressLike,
  type FetchFunction,
} from 'supertest-fetch';
import { AppModule } from './../src/app.module';

describe('AppController (e2e)', () => {
  let fetch: FetchFunction;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    const app: INestApplication<IExpressLike> =
      moduleFixture.createNestApplication();
    await app.init();
    fetch = makeFetch(app.getHttpServer());
  });

  it('/ (GET)', () => {
    return fetch('/').expect(200).expect('Hello World!');
  });
});
