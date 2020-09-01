import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import { isLoggedIn } from "./../../../backend/requests/user";

Vue.use(VueRouter)
  // ARRAY CON LAS RUTAS A LAS VISTAS DEL PROYECTO
  const routes = [
    {
      path: '/',
      name: 'Home',
      component: Home,
      meta: { // RUTA ABIERTA A TODOS LOS USUARIOS
        allowAnon: true
      }
    },
    {
      path: '/about',
      name: 'About', // RUTA ABIERTA A TODOS LOS USUARIOS
      component: () => import('../views/About.vue'),
      meta: {
        allowAnon: true
      }
    },
    {
      path: '/add-space',
      name: 'AddSpace', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/AddSpace.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '/space-list',
      name: 'SpaceList', // RUTA ABIERTA A TODOS LOS USUARIOS
      component: () => import('../views/SpaceList.vue'),
      meta: {
        allowAnon: true
      }
    },
    {
      path: '/space-provider-list',
      name: 'SpaceProviderList', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/SpaceProviderList.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '/space-detail/:id/',
      name: 'SpaceDetail', // RUTA ABIERTA A TODOS LOS USUARIOS
      component: () => import('../views/SpaceDetail.vue'),
      meta: {
        allowAnon: true
      }
    },
    {
      path: '/update-space',
      name: 'UpdateSpace', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/UpdateSpace.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '/book-list',
      name: 'BookList', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/BookList.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '/add-book',
      name: 'AddBook', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/AddBook.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '/user',
      name: 'User', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/User.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '/register',
      name: 'Register', // RUTA ABIERTA A TODOS LOS USUARIOS
      component: () => import('../views/Register.vue'),
      meta: {
        allowAnon: true
      }
    },
    {
      path: '/login', // RUTA ABIERTA A TODOS LOS USUARIOS
      name: 'Login',
      component: () => import('../views/Login.vue'),
      meta: {
        allowAnon: true
      }
    },
    {
      path: '/update-user',
      name: 'UpdateUser', // RUTA RESTRINGIDA A LOS USUARIOS AUTENTICADOS
      component: () => import('../views/UpdateUser.vue'),
      meta: {
        allowAnon: false
      }
    },
    {
      path: '*',
      name: 'Error',
      component: () => import('../views/Error.vue'),
      meta: {
        allowAnon: true
      }
    }
]

const router = new VueRouter({
  routes
})
// FUNCIÓN DE COMPROBACIÓN DE RESTRICCIÓN DE RUTA Y AUTENTICACIÓN DE USUARIO
router.beforeEach((to, from, next) => {
  if(!to.meta.allowAnon && !isLoggedIn()){
    next({
      path: '/login',
      query: { redirect: to.fullPath }
    })
  } else {
    next()
  }
})

export default router
